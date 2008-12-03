require File.dirname(__FILE__) + '/../spec_helper'

describe "Quickadmin::Validates (controller)" do
  
  # Feel free to remove the specs below
  
  before :all do
    Merb::Router.prepare { add_slice(:Quickadmin) } if standalone?
  end
  
  after :all do
    Merb::Router.reset! if standalone?
  end
  
  it "should have access to the slice module" do
    controller = dispatch_to(Quickadmin::Main, :index)
    controller.slice.should == Quickadmin
    controller.slice.should == Quickadmin::Main.slice
  end
  
  it "should have an index action" do
    controller = dispatch_to(Quickadmin::Main, :index)
    controller.status.should == 200
    controller.body.should contain('Quickadmin')
  end
  
  it "should work with the default route" do
    controller = get("/quickadmin/main/index")
    controller.should be_kind_of(Quickadmin::Main)
    controller.action_name.should == 'index'
  end
  
  it "should work with the example named route" do
    controller = get("/quickadmin/index.html")
    controller.should be_kind_of(Quickadmin::Main)
    controller.action_name.should == 'index'
  end
    
  it "should have a slice_url helper method for slice-specific routes" do
    controller = dispatch_to(Quickadmin::Main, 'index')
    
    url = controller.url(:quickadmin_default, :controller => 'main', :action => 'show', :format => 'html')
    url.should == "/quickadmin/main/show.html"
    controller.slice_url(:controller => 'main', :action => 'show', :format => 'html').should == url
    
    url = controller.url(:quickadmin_index, :format => 'html')
    url.should == "/quickadmin/index.html"
    controller.slice_url(:index, :format => 'html').should == url
    
    url = controller.url(:quickadmin_home)
    url.should == "/quickadmin/"
    controller.slice_url(:home).should == url
  end
  
  it "should have helper methods for dealing with public paths" do
    controller = dispatch_to(Quickadmin::Main, :index)
    controller.public_path_for(:image).should == "/slices/quickadmin/images"
    controller.public_path_for(:javascript).should == "/slices/quickadmin/javascripts"
    controller.public_path_for(:stylesheet).should == "/slices/quickadmin/stylesheets"
    
    controller.image_path.should == "/slices/quickadmin/images"
    controller.javascript_path.should == "/slices/quickadmin/javascripts"
    controller.stylesheet_path.should == "/slices/quickadmin/stylesheets"
  end
  
  it "should have a slice-specific _template_root" do
    Quickadmin::Main._template_root.should == Quickadmin.dir_for(:view)
    Quickadmin::Main._template_root.should == Quickadmin::Application._template_root
  end

end