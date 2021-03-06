module Quickadmin::Mixins

  module EnsureQuickadmin

    def ensure_quickadmin
      unless session[:quickadmin]
        session[:return_to] = request.uri
        throw :halt, Proc.new{ |c| c.redirect url(:quickadmin_openid) }
      end
    end

  end

end
