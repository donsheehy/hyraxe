require 'rubygems'
require 'haml'
require 'hashie'

module Hyraxe
  
  class Base
    def initialize
      @scope = RenderScope.new
      @data_loader = DataLoader.new("", @scope)
      @renderer = Renderer.new(@data_loader, @scope)
    end
  end
  
  class DataLoader
    attr_reader :pages, :partials, :multi_pages, :scope, :yaml_files

    def initialize(path, scope = RenderScope.new)
      @scope = scope
      @path = path
      load_all_yaml_files
      load_all_haml_files
      initialize_haml_partials
    end

    def load_yaml(file_name)
      items = YAML.load_file(file_name)
      items.is_a?(Array) ? items.map{|item| Hashie::Mash.new(item)} : Hashie::Mash.new(items)
    end
    
    def load_all_yaml_files
      @yaml_files = Dir.glob(@path + "data/*.yaml")
      @yaml_files.each do |file|
        yaml = load_yaml(file)
        file_symbol = "@#{file.split("/").last.split('.').first}".to_sym
        @scope.instance_variable_set(file_symbol, yaml)
      end
    end
    
    def load_all_haml_files
      haml_files = Dir.glob(@path + "*.haml")
      page_files = haml_files.select{ |f| f.match /\.html\.haml/ } 
      multi_page_files = haml_files.select{ |f| f.match /\.multi\.haml/} 
      partial_files = haml_files - page_files - multi_page_files
      
      @pages        = page_files.map{ |file| load_haml(file) }
      @multi_pages  = multi_page_files.map{ |file| load_haml(file) }
      @partials     = partial_files.map{ |file| load_haml(file) }
    end
    
    def load_haml(file_name)
      Page.new "#{file_name.split("/").last.split('.').first}".to_sym, File.read(file_name), file_name
    end

    def initialize_haml_partials
      @partials.each do |partial|
        @scope.new_partial(partial)
      end      
    end

  end
  
  # This class just collects methods and instance variables for use in the haml templates.
  class RenderScope
    def initialize
      @partials = Hash.new
    end
    
    def new_partial(partial)
      @partials[partial.base_name] = partial
      # self.class.send(:define_method, method_name, &block)
    end
    
    def method_missing(m, *args, &block) 
      partial = @partials[m]
      if partial
        partial.engine.render{ capture_haml { yield } }
      end
    end
  end
  
  class Page
    attr_reader :base_name, :haml, :path, :engine
    
    def initialize(base_name, haml, path)
      @base_name = base_name
      @haml = haml
      @path = path
      @engine = Haml::Engine.new(@haml)
    end
    
    def render
      engine = Haml::Engine.new(haml)
      html_file = File.open(path[0..-6], "w")
      html_file.puts engine.render(@scope)
      html_file.close
    end
    
  end
  
  class Renderer
    def initialize(data_loader, scope)
      @path = File.dirname(__FILE__) + "test_site/"
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
      page.render
    end
    
    # render a collection of pages ( a multi_page )
    def render_multi(multi)
    end
    
  end
  
  
end