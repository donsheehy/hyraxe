require File.dirname(__FILE__) + '/spec_helper'

describe Hyraxe::DataLoader do
  before :each do
    @path = File.dirname(__FILE__) + "/test_site/"
    @data_loader = Hyraxe::DataLoader.new(@path)
  end
  
  it "should load a yaml file with an array" do
    data = @data_loader.load_yaml(@path + "data/list.yaml")
    data[0].name.should == 'foo'
    data[0].color.should == 'blue' 
    data[1].name.should == 'bar'
    data[1].color.should == 'red'     
  end
  
  it "should load a yaml file that is not a list" do
    data = @data_loader.load_yaml(@path + "data/hash.yaml")
    data.id.should == "Just a list of variables"  # note Mash overrides id
    data.string.should == "string"
    data.one.should == 1
    data.two.should == 2
  end
  
  it "should load a haml file" do
    path = @path + "index.html.haml"
    page = @data_loader.load_haml(path)

    page.base_name.should == :index
    page.haml.should match(/This is the main page\./)
    page.path.should == path
  end
  
  it "should load all of the yaml files in the data folder" do
    @data_loader.yaml_files.size.should == 2
    @data_loader.yaml_files[0].should match(/hash.yaml/)
    @data_loader.yaml_files[1].should match(/list.yaml/)
  end
  
  it "should create an instance variables on the scope for each yaml file" do
    @data_loader.scope.instance_variable_defined?(:@hash).should be_true
    @data_loader.scope.instance_variable_defined?(:@list).should be_true
  end
  
  it "should create a method on the scope for each .haml file" do
    @data_loader.scope.should respond_to(:layout)
    @data_loader.scope.should respond_to(:partial)
    @data_loader.scope.should_not respond_to(:index)
    @data_loader.scope.should_not respond_to(:list)
  end
  
  it "should load all of the haml files as strings and expose them by type" do
    @data_loader.pages.should_not be_nil
    @data_loader.partials.should_not be_nil
    @data_loader.multi_pages.should_not be_nil
  end
  
end