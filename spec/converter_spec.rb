require File.dirname(__FILE__) + '/spec_helper'

require 'converter'

describe Php2Rb::Converter do

  it "should convert +" do
    php("1 + 2").should equal_ruby("1 + 2")
  end
  it "should convert echoing a statement" do
    php("echo(1 + 2)").should equal_ruby("print(1 + 2)")
  end

  it "should convert echoing a string" do
    php("echo('spam')").should equal_ruby("print('spam')")
  end

  it "should convert strings" do
    php('"foo"').should equal_ruby('"foo"')
  end

  it "should allow variables" do
    php("echo($x)").should equal_ruby("print x")
  end

  it "should convert assignment" do
    php("$x = 42").should equal_ruby("x = 42")
  end

  it "should convert if/then/else" do
    php("if ($x == 42) { echo('foo'); } else { echo ('bar'); }").should equal_ruby(
      "if x == 42 \n print('foo') \n else \n print('bar') \n end")
  end

  it "should convert function definition" do
    php("function fun($x, $y) { echo('running function'); return $x + $y; }").should equal_ruby(
      "def fun(x, y) \n print('running function') \n return x + y \n end")
  end

  it "should convert block statements" do
    php("echo('hello '); \n echo('world');").should equal_ruby(
      "print('hello ')\nprint('world')")
  end

  it "should convert equality checks" do
    php("$x == 42").should equal_ruby("x == 42")
  end

end