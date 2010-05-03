require 'rubygems'
require 'haml'

def layout
  layout_engine = Haml::Engine.new(IO.read("layout.haml"))
  layout_engine.render{ capture_haml { yield } }
end

engine = Haml::Engine.new(IO.read("index.html.haml"))
puts engine.render


