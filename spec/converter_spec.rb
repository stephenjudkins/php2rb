require File.dirname(__FILE__) + '/spec_helper'

require 'converter'

describe Php2Rb::Converter do

  describe "with arithmetic expressions" do
    it "should convert +" do
      php("1 + 2").should equal_ruby("1 + 2")
    end

    it "should convert -" do
      php("1 - 2").should equal_ruby("1 - 2")
    end

    it "should convert *" do
      php("1 * 2").should equal_ruby("1 * 2")
    end

    it "should convert /" do
      php("1 / 2").should equal_ruby("1 / 2")
    end

    it "should convert nested expressions" do
      php("((500/3) * 100 + 3) - (10 * 5 + (2*3*(72/2)))").should equal_ruby(
        "((500/3) * 100 + 3) - (10 * 5 + (2*3*(72/2)))")
    end
  end

  describe "with literals" do
    it "should convert strings" do
      php('"foo"').should equal_ruby('"foo"')
    end

    it "should convert integers" do
      php("5").should equal_ruby("5")
    end

    it "should convert floats" do
      php("3.14").should equal_ruby("3.14")
    end

  end
  it "should convert echoing a statement" do
    php("echo(1 + 2)").should equal_ruby("print(1 + 2)")
  end

  it "should convert echoing a string" do
    php("echo('spam')").should equal_ruby("print('spam')")
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

  it "should convert function definition with default arguments" do
    php("function fun($x, $y = \"foo\") {return $x;}").should equal_ruby(
      "def fun(x, y='foo') \n return x \n end")
  end

  it "should convert block statements" do
    php("echo('hello '); \n echo('world');").should equal_ruby(
      "print('hello ')\nprint('world')")
  end

  describe "with boolean expressions" do
    it "should convert equality checks" do
      php("$x == 42").should equal_ruby("x == 42")
    end

    it "should convert gt" do
      php("$x > 42").should equal_ruby("x > 42")
    end

    it "should convert lt" do
      php("$x < 42").should equal_ruby("x < 42")
    end

  end

  it "should convert function calls" do
    php("foo(\"bar\", $spam);").should equal_ruby("foo('bar', spam)")
  end

  it "should convert appending" do
    php('"foo".$b').should equal_ruby('"foo" + b')
  end

  it "should convert class definitions" do
    php("class Foo {}").should equal_ruby("class Foo; end")
  end

  it "should convert constant definition" do
    php("define( 'MW_PARSER_VERSION', '1.6.1' )").should equal_ruby("MW_PARSER_VERSION = '1.6.1'")
  end
  
  it "should convert arrays" do
    php("array(1,2,'hello')").should equal_ruby("[1,2,'hello']")
  end
  
  it "should convert an associative array" do
    php("array('foo' => 'bar', 'spam' => 'eggs')").should equal_ruby("{'foo' => 'bar', 'spam' => 'eggs'}")
  end


end