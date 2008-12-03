# -*- encoding: utf-8 -*-

Gem::Specification.new do |s|
  s.name = %q{quickadmin}
  s.version = "1.0.3"

  s.required_rubygems_version = Gem::Requirement.new(">= 0") if s.respond_to? :required_rubygems_version=
  s.authors = ["Mark Percival"]
  s.date = %q{2008-12-03}
  s.description = %q{Merb Slice adds quick DB'less OpenID authentication to your app}
  s.email = %q{mark@mpercival.com}
  s.extra_rdoc_files = ["README", "LICENSE", "TODO"]
  s.files = ["LICENSE", "README", "Rakefile", "TODO", "lib/admins.yaml", "lib/quickadmin", "lib/quickadmin/merbtasks.rb", "lib/quickadmin/mixins", "lib/quickadmin/mixins/ensure_quickadmin.rb", "lib/quickadmin/slicetasks.rb", "lib/quickadmin/spectasks.rb", "lib/quickadmin.rb", "spec/controllers", "spec/controllers/main_spec.rb", "spec/quickadmin_spec.rb", "spec/spec_helper.rb", "app/controllers", "app/controllers/application.rb", "app/controllers/validates.rb", "app/helpers", "app/helpers/application_helper.rb", "app/models", "app/models/admin.rb", "app/views", "app/views/layout", "app/views/layout/quickadmin.html.erb", "app/views/validates", "app/views/validates/openid.html.haml", "public/javascripts", "public/javascripts/master.js", "public/stylesheets", "public/stylesheets/master.css", "stubs/app", "stubs/app/controllers", "stubs/app/controllers/application.rb", "stubs/app/controllers/main.rb"]
  s.has_rdoc = true
  s.homepage = %q{http://github.com/markpercival/quickadmin}
  s.require_paths = ["lib"]
  s.rubyforge_project = %q{merb}
  s.rubygems_version = %q{1.3.1}
  s.summary = %q{Merb Slice adds quick DB'less OpenID authentication to your app}

  if s.respond_to? :specification_version then
    current_version = Gem::Specification::CURRENT_SPECIFICATION_VERSION
    s.specification_version = 2

    if Gem::Version.new(Gem::RubyGemsVersion) >= Gem::Version.new('1.2.0') then
      s.add_runtime_dependency(%q<merb-slices>, [">= 1.0.3"])
    else
      s.add_dependency(%q<merb-slices>, [">= 1.0.3"])
    end
  else
    s.add_dependency(%q<merb-slices>, [">= 1.0.3"])
  end
end
