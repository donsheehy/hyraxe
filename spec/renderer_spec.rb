require File.dirname(__FILE__) + '/spec_helper'
require 'fakefs/safe'

describe Hyraxe::Renderer do
  before :each do    
    @path = File.dirname(__FILE__) + "/test_site/"
    @scope = Hyraxe::RenderScope.new
    @data_loader = Hyraxe::DataLoader.new(@path, @scope)
    @renderer = Hyraxe::Renderer.new(@data_loader, @scope)    
  end
    
  it "should create a .html for a .html.haml file" do
    page = @data_loader.pages[0]
    FakeFS do
      @renderer.render_page(page)
      File.exists?(@path + "index.html").should be_true
    end  
  end
  
end