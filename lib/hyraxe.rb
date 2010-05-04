require 'rubygems'
require 'haml'
require 'hashie'

module Hyrax
  
  class Base
    def initialize
      @scope = RenderScope.new
      @data_loader = DataLoader.new(@scope)
      @renderer = Renderer.new(@data_loader, @scope)
    end
  end
  
  class DataLoader
    attr_accessor :yaml_files
    attr_accessor :scope

    def initialize(path, scope = RenderScope.new)
      @scope = scope
      load_all_yaml_files path      
    end

    def load_yaml(file_name)
      items = YAML.load_file(file_name)
      items.is_a?(Array) ? items.map{|item| Hashie::Mash.new(item)} : Hashie::Mash.new(items)
    end
    
    def load_all_yaml_files(path)
      @yaml_files = Dir.glob(path + "data/*.yaml")
      @yaml_files.each do |file|
        yaml = load_yaml(file)
        file_symbol = "@#{file.split("/").last.split('.').first}".to_sym
        @scope.instance_variable_set(file_symbol, yaml)
      end
    end
    
    def load_haml(file_name)
      File.read(file_name)
    end
  end
  
  # This class just collects methods and instance variables for use in the haml templates.
  class RenderScope

  end
  
  class Renderer
    def initialize(data_loader, scope)
      @data_loader = data_loader
      @scope = scope
    end
    
    # render all of the loaded pages and multi pages
    def render_all
      @data_loader.pages.each { |p| render_page p }
      @data_loader.multi_pages.each { |m| render_multi m }
    end  
      
    # render a single page
    def render_page(page)
    end
    
    # render a collection of pages ( a multi_page )
    def render_multi(multi)
    end
    
  end
  
  
end