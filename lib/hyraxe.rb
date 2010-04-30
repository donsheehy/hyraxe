require 'rubygems'
require 'haml'
require 'hashie'

module Hyrax
  
  class DataLoader
    def load_file(file_name)
      items = YAML.load_file(file_name)
      items.is_a?(Array) ? items.map{|item| Hashie::Mash.new(item)} : Hashie::Mash.new(items)
    end
  end
  
  class Renderer
    
  end
  
end