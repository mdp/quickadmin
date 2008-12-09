if defined?(Merb::Plugins)

  $:.unshift File.dirname(__FILE__)

  dependency 'merb-slices'
  Merb::Plugins.add_rakefiles "quickadmin/merbtasks", "quickadmin/slicetasks", "quickadmin/spectasks"

  # Register the Slice for the current host application
  Merb::Slices::register(__FILE__)
  
  # Slice configuration - set this in a before_app_loads callback.
  # By default a Slice uses its own layout, so you can swicht to 
  # the main application layout or no layout at all if needed.
  # 
  # Configuration options:
  # :layout - the layout to use; defaults to :quickadmin
  # :mirror - which path component types to use on copy operations; defaults to all
  Merb::Slices::config[:quickadmin][:layout] ||= :application
  
  # All Slice code is expected to be namespaced inside a module


  module Quickadmin
  require 'quickadmin/mixins/ensure_quickadmin.rb'
    
    # Slice metadata
    self.description = "Quickadmin makes admin logins easy"
    self.version = "1.0.3"
    self.author = "Mark Percival"
    
    # Stub classes loaded hook - runs before LoadClasses BootLoader
    # right after a slice's classes have been loaded internally.
    def self.loaded
    end
    
    # Initialization hook - runs before AfterAppLoads BootLoader
    def self.init
      unless File.exist?(Merb.root / 'config' /  'quickadmins.yaml')
        Merb.logger.info("Creating initial quickadmins.yaml file")
        File.new(Merb.root / 'config' /  'quickadmins.yaml', 'w').puts(sample_yaml)
      end
    end
    
    # Activation hook - runs after AfterAppLoads BootLoader
    def self.activate
      result = ::Application.class_eval { include Quickadmin::Mixins::EnsureQuickadmin }
      Merb.logger.info("Including EnsureQuickadmin mixin into #{result}")
    end
    
    # Deactivation hook - triggered by Merb::Slices.deactivate(Quickadmin)
    def self.deactivate
    end
    
    # Setup routes inside the host application
    #
    # @param scope<Merb::Router::Behaviour>
    #  Routes will be added within this scope (namespace). In fact, any 
    #  router behaviour is a valid namespace, so you can attach
    #  routes at any level of your router setup.
    #
    # @note prefix your named routes with :quickadmin_
    #   to avoid potential conflicts with global named routes.
    def self.setup_router(scope)
      scope.match('/openid').to(:controller => 'validates', :action => 'openid').name(:openid)
      scope.match('/logout').to(:controller => 'validates', :action => 'logout').name(:logout)
    end
    
    protected
    
    def self.sample_yaml
      sample = <<EOF
- mark.mpercival.com
- john.schult.us
- ivey.gweezlebur.com
EOF
    end
    
  end
  
  # Setup the slice layout for Quickadmin
  #
  # Use Quickadmin.push_path and Quickadmin.push_app_path
  # to set paths to quickadmin-level and app-level paths. Example:
  #
  # Quickadmin.push_path(:application, Quickadmin.root)
  # Quickadmin.push_app_path(:application, Merb.root / 'slices' / 'quickadmin')
  # ...
  #
  # Any component path that hasn't been set will default to Quickadmin.root
  #
  # Or just call setup_default_structure! to setup a basic Merb MVC structure.
  Quickadmin.setup_default_structure!
  
  # Add dependencies for other Quickadmin classes below. Example:
  # dependency "quickadmin/other"
  
  dependency "ruby-openid", :require_as => "openid"
  dependency 'merb-haml'
  dependency 'merb-helpers'
  
end