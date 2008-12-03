# This file is here so slice can be testing as a stand alone application.

Merb::Router.prepare do
  slice(:quickadmin, :name_prefix => nil, :path_prefix => "")
end