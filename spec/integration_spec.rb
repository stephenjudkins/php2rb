require File.dirname(__FILE__) + '/spec_helper'
require 'tempfile'

describe Converter, "runs real PHP scripts correctly" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  Dir.glob(File.dirname(__FILE__) + '/integration/*.php').each do |filename|
    php = File.read(filename)
    pipe = IO.popen('phc --dump-ast-xml', 'w+')
    pipe.puts php
    pipe.close_write

    xml = pipe.readlines.join("\n")


    it "should run #{filename}" do
      ruby = @converter.convert(xml)
      tmp = Tempfile.new "test_script.rb"
      tmp.puts ruby
      tmp.close

      ruby_output = `ruby #{tmp.path}`
      php_output = `php #{filename}`
      php_output.should == ruby_output
    end
  end
end
