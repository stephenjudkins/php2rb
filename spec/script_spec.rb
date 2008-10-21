require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " converts entire scripts" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  it "converts entire scripts" do
    xml = File.read(File.dirname(__FILE__) + '/full_script.xml')
    @converter.eval(e(xml)).should == 'foo = true
if foo
  print("yes!")
else
  print("no!")
end'
    
  end
end
