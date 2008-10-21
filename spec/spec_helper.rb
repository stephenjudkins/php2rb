require 'rubygems'
require 'spec'
require 'cgi'
require File.expand_path(File.dirname(__FILE__) + '/../converter')

def e(xml)
  REXML::Document.new(xml).root
end

def debug(str)
  puts CGI.escapeHTML(str.inspect)
end