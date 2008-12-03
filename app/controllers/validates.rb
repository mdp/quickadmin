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
    "#{request.protocol}://#{request.host}#{Merb::Router.url(:openid)}"
  end

  # Overwrite the on_success! method with the required behavior for successful logins
  #
  # @api overwritable
  def on_success!(response, sreg_response)
    if user = find_user_by_identity_url(response.identity_url)
      user
    else
      request.session[:'openid.url'] = response.identity_url
      required_reg_fields.each do |f|
        session[:"openid.#{f}"] = sreg_response.data[f] if sreg_response.data[f]
      end if sreg_response
      redirect!(Merb::Router.url(:signup))
    end
  end

  # Overwrite the on_failure! method with the required behavior for failed logins
  #
  # @api overwritable
  def on_failure!(response)
    session.authentication.errors.clear!
    session.authentication.errors.add(:openid, 'OpenID verification failed, maybe the provider is down? Or the session timed out')
    nil
  end

  #
  # @api overwritable
  def on_setup_needed!(response)
    request.session.authentication.errors.clear!
    request.session.authentication.errors.add(:openid, 'OpenID does not seem to be configured correctly')
    nil
  end

  #
  # @api overwritable
  def on_cancel!(response)
    request.session.authentication.errors.clear!
    request.session.authentication.errors.add(:openid, 'OpenID rejected our request')
    nil
  end

  #
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
