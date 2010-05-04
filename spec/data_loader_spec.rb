require File.dirname(__FILE__) + '/spec_helper'

describe Hyrax::DataLoader do
  before :each do
    @path = File.dirname(__FILE__) + "/test_site/"
    @data_loader = Hyrax::DataLoader.new(@path)
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
    haml_file = @data_loader.load_haml(@path + "index.html.haml")
    haml_file.should be_a(String)
    haml_file.split("\n")[0].should == "%h1 This is the main page."
  end
  
  it "should load all of the yaml files in the data folder" do
    @data_loader.yaml_files.size.should == 2
    @data_loader.yaml_files[0].should match(/hash.yaml/)
    @data_loader.yaml_files[1].should match(/list.yaml/)
  end
  
  it "should create an instance variables on the scope for each yaml file" do
    @data_loader.scope.instance_variables.should == ["@hash", "@list"] 
  end
  
end