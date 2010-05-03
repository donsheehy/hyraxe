require 'rubygems'
require 'haml'
require 'hashie'

module Hyrax
  
  class DataLoader
    attr_accessor :yaml_files

    def initialize(path)
      @yaml_files = Dir.glob(path + "data/*.yaml")

    end

    def load_yaml(file_name)
      items = YAML.load_file(file_name)
      items.is_a?(Array) ? items.map{|item| Hashie::Mash.new(item)} : Hashie::Mash.new(items)
    end
    
    def load_haml(file_name)
      File.read(file_name)
    end
  end
  
  class Renderer
  end
  
  
end