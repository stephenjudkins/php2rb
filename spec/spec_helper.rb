require 'rubygems'
require 'spec'

require File.dirname(__FILE__) + '/../converter'

def e(xml)
  REXML::Document.new(xml).root
end