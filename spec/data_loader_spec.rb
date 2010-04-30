require File.dirname(__FILE__) + '/spec_helper'

describe Hyrax::DataLoader do
  before :each do
    @dir = File.dirname(__FILE__)
    @data_loader = Hyrax::DataLoader.new
  end
  
  it "should load a yaml file with an array" do
    data = @data_loader.load_file(@dir + "/test_site/list.yaml")
    data[0].name.should == 'foo'
    data[0].color.should == 'blue' 
    data[1].name.should == 'bar'
    data[1].color.should == 'red'     
  end
  
  it "should load a yaml file that is not a list" do
    data = @data_loader.load_file(@dir + "/test_site/hash.yaml")
    data.id.should == "Just a list of variables"  # note Mash overrides id
    data.string.should == "string"
    data.one.should == 1
    data.two.should == 2
  end
  
end