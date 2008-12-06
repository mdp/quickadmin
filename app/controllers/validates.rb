require 'openid'
require 'openid/store/filesystem'
require 'openid/extensions/sreg'

class Quickadmin::Validates < Quickadmin::Application

  def openid
    if request.params[:'openid.mode']
      response = consumer.complete(request.send(:query_params), "#{request.protocol}://#{request.host}" + request.path)
      case response.status.to_s
      when 'success'
        # sreg_response = ::OpenID::SReg::Response.from_success_response(response)
        Merb.logger.info("Quickadmin found - #{Quickadmin::Admin.find(response.identity_url)}")
        if session[:quickadmin] = Quickadmin::Admin.find(response.identity_url)
          redirect session[:return_to] ? session[:return_to] : '/'
        else
          render
        end
      when 'failure'
        message[:notice] = "OpenID verification failed!"
        render
      when  'setup_needed'
        message[:notice] = "You're OpenID needs setup!"
        render
      when 'cancel'
        message[:notice] = "You cancelled the OpenID login!"
        render
      end

    elsif identity_url = params[:openid_url]
      begin
        openid_request = consumer.begin(identity_url)
        openid_reg = ::OpenID::SReg::Request.new
        openid_reg.request_fields(required_reg_fields)
        openid_request.add_extension(openid_reg)
        redirect(openid_request.redirect_url("#{request.protocol}://#{request.host}", openid_callback_url))
      rescue ::OpenID::OpenIDError => e
        message[:notice] = "There was a failure communicating with the OpenID provider"
        render
      end
    else
      render
    end
  end
  
  def logout
    session[:quickadmin] = nil
    redirect '/'
  end

  private

  def openid_callback_url
    "#{request.protocol}://#{request.host}#{Merb::Router.url(:quickadmin_openid)}"
  end

  # @api overwritable
  def required_reg_fields
    ['email']
  end

  # Overwrite this method to set your store
  #
  # @api overwritable
  def openid_store
    ::OpenID::Store::Filesystem.new("#{Merb.root}/tmp/openid")
  end

  private
  def consumer
    @consumer ||= ::OpenID::Consumer.new(request.session, openid_store)
  end

end
