$: << File.dirname(__FILE__)
$: << File.expand_path(File.dirname(__FILE__) + '/../lib')
require 'pp'

def php(expr)
  Php2Rb::Converter.convert("<? #{expr} ?>")
end

def equal_ruby(ruby)
  EqualRuby.new(ruby)
end
  
class EqualRuby
  def initialize(ruby)
    @ruby = ruby
    @expected_sexp = RubyParser.new.process(@ruby)
  end

  def matches?(sexp)
    @sexp_string = sexp.inspect

    @sexp = begin
      # sexp
      normalize_sexp(sexp)
    rescue Exception
      nil
    end

    @sexp == @expected_sexp
  end

  def failure_message
    return broken unless @sexp

    begin
      @expected_ruby = Ruby2Ruby.new.process(@sexp)
    rescue Exception => e
      return broken
    end
    "===expected===\n#{@ruby}\n===to be the same as===\n" +
    "#{@expected_ruby}\n===ruby expectation produced===\n#{@expected_sexp.inspect}\n" +
    "===php produced===\n#{@sexp_string}"
  end
  
  def broken
    "===couldn't parse===\n" + 
    "#{@sexp_string}\n===expected===\n#{@expected_sexp.inspect}"
  end
end

def normalize_sexp(sexp)
  RubyParser.new.process(Ruby2Ruby.new.process(sexp))
end