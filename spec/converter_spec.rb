require File.dirname(__FILE__) + '/spec_helper'

require 'converter'

describe Php2Rb::Converter do

  describe "with arithmetic expressions" do
    ["+", "-", "*", "/", "%"].each do |op|
      it "should convert #{op}" do
        php("1 #{op} 2").should equal_ruby("1 #{op} 2")
      end
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

    it "should convert 'true'" do
      php("true").should equal_ruby("true")
    end

    it "should convert 'false'" do
      php("false").should equal_ruby("false")
    end

    it "should convert 'null'" do
      php("null").should equal_ruby("nil")
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

  it "should convert if/then" do
    php("if ($x == 42) { echo('the meaning of life')}").should equal_ruby(
      "print 'the meaning of life' if x == 42")
  end

  it "should convert method definition" do
    php("function fun($x, $y) { echo('running function'); return $x + $y; }").should equal_ruby(
      "def fun(x, y) \n print('running function') \n return x + y \n end")
  end

  it "should convert method definition with default arguments" do
    php("function fun($x, $y = \"foo\") {return $x;}").should equal_ruby(
      "def fun(x, y='foo') \n return x \n end")
  end

  it "should convert method definition with no block" do
    php("function fun() {}").should equal_ruby("def fun; end")
  end

  it "should convert block statements" do
    php("echo('hello '); \n echo('world');").should equal_ruby(
      "print('hello ')\nprint('world')")
  end

  describe "with boolean expressions" do

    ["==", ">", "<", ">=", "<=", "!=", "&", "^", "|", "&&", "||"].each do |op|
      it "should convert #{op}" do
        php("1 #{op} 2").should equal_ruby("1 #{op} 2")
      end
    end

    it "should convert xor" do
      php("a xor b").should equal_ruby("a ^ b")
    end
    # it "should convert bitwise and" do
    #   php("$a & $b").should equal_ruby("a & b")
    # end
    #
    # it "should convert bitwise xor" do
    #   php("$a ^ $b").should equal_ruby("a ^ b")
    # end
    #
    # it "should convert bitwise not" do
    #   php("( ~ $b )").should equal_ruby("(~ b)")
    # end
    #
    # it "should convert bitwise or" do
    #   php("$a | $b").should equal_ruby("a | b")
    # end
  end

  it "should convert method calls" do
    php("foo(\"bar\", $spam);").should equal_ruby("foo('bar', spam)")
  end

  it "should convert appending" do
    php('"foo".$b').should equal_ruby('"foo" + b')
  end

  it "should convert class definitions" do
    php("class Foo {}").should equal_ruby("class Foo; end")
  end

  it "should convert class definitions with inheritance" do
    php("class MyClass extends ThatClass {}").should equal_ruby("class MyClass < ThatClass; end")
  end

  it "should convert field definitions in a class def" do
    php(
      "class ThingO { var $a, $b, $c; }").
    should equal_ruby(
      "class ThingO
        attr_accessor :a
        attr_accessor :b
        attr_accessor :c
      end")
  end

  it "should convert methods with class definitions" do
    php("class Foo { function bar() { return 'hello world';} }").should equal_ruby(
      "class Foo \n def bar \n return 'hello world' \n end \n end")
  end

  # the only way I can determine the order of these functions is line number.
  it "should convert classes with multiple methods" do
    php("class Foo {
          function bar() { return 'hello world';}
          function spam() { return 'eggs'; }
        }").should equal_ruby(
      "class Foo
        def bar; return 'hello world'; end
        def spam; return 'eggs'; end
      end")
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

  it "should convert a foreach statement" do
    php(
    "foreach ($arr as $value) {
       echo($value);
    }").should equal_ruby(
    "arr.each {|value| print(value) }")
  end

  it "should convert a foreach over an associative array" do
    php(
      "foreach($scores as $key => $score) { echo($key)}").
    should equal_ruby(
      "scores.each {|key, score| print(key)}")
  end

  it "should convert an array get" do
    php("$foo['bar']").should equal_ruby("foo['bar']")
  end

  it "should allow assigning to array double-gets (why, Quercus? why?)" do
    php("$foo[1][2] = $var").should equal_ruby("foo[1][2] = var")
  end

  it "should assign to arrays" do
    php("$foo['bar'] = 100").should equal_ruby("foo['bar'] = 100")
  end

  it "should allow static class methods" do
    php(
    "static $static = true").should equal_ruby("php_static_var :static => true")
  end

  it "should allow static method invocation" do
    php("Foo::bar('arg1', 2)").should equal_ruby("Foo.bar('arg1', 2)")
  end

  it "should allow invoking methods in expressions" do
    php("foo(bar('spam'))").should equal_ruby("foo(bar('spam'))")
  end

  it "should parse isset for variables" do
    php("isset($foo)").should equal_ruby("defined? foo")
  end

  it "should convert method calls on objects" do
    php("$foo->bar()").should equal_ruby("foo.bar")
  end

  it "should convert accessing fields on $this to instance variables" do
    php("$this->foo").should equal_ruby("@foo")
  end

  it "should convert changing fields on $this to assigning instance vars" do
    php("$this->foo = 'bar'").should equal_ruby("@foo = 'bar'")
  end

  it "should convert calling methods on $this to self" do
    php("$this->spam()").should equal_ruby("self.spam")
  end

  it "should convert 'not'" do
    php("!$foo").should equal_ruby("!foo")
  end

  # note: there are pretty big semantic differences between PHP's "switch" and
  # Ruby's "case".  however, Quercus is nice enough to parse the case statement in a way
  # that we can generate code that performs equivalently.  However, this approach may duplicating a lot of code.
  # however, if the PHP is written without "break" or "return" statements then it's probably really ugly code anyways.
  # generally, things should work out OK (knock on wood)
  it "should convert switch statements" do
    php(
    "switch($i):
      case 1:
        echo('1');
      case 2:
        echo('2');
        break;
      case 3:
        return 'foo';
      default:
        echo('default');
      endswitch;
    ").should equal_ruby("
      case(i)
      when 1
        print '1'
        print '2'
      when 2
        print '2'
      when 3
        return 'foo'
      else
        print 'default'
      end
    ")
  end

  it "should convert switch statements without a default, without adding comments in" do
    sexp = php(
    "switch($i):
      case 1: echo('1'); break;
      case 2: echo('2');
     endswitch;")

     Ruby2Ruby.new.process(sexp).should_not =~ /do nothing/
  end

  it "should convert continue statements" do
    php("foreach ($arr as $v) { continue; }").should equal_ruby(
      "arr.each {|v| next }")
  end

  describe "with continue statements jumping an extra loop out" do
    it "should use special runtime forloops that allow for it" do
      php(
        "foreach ($a as $i) { foreach ($b as $j) { continue 2; }}"
      ).should equal_ruby(
        "Php2Rb.foreach(a) { |i| Php2Rb.foreach(b) { |j| Php2Rb.continue(2) } }"
      )
    end

    it "should use special loops even if it is nested in an 'if' statement" do
      php(
        "foreach ($a as $i) { foreach ($b as $j) { if ($j == 42) { continue 2; } }}"
      ).should equal_ruby(
        "Php2Rb.foreach(a) { |i| Php2Rb.foreach(b) { |j| Php2Rb.continue(2) if j == 42 } }"
      )
    end

  end

  describe "with break statements jumping an extra loop out" do
    it "should use special runtime forloops that allow for it" do
      php(
        "foreach ($a as $i) { foreach ($b as $j) { break 2; }}"
      ).should equal_ruby(
        "Php2Rb.foreach(a) { |i| Php2Rb.foreach(b) { |j| Php2Rb.break(2) } }"
      )
    end
    it "should use special loops even if it is nested in an 'if' statement" do
      php(
        "foreach ($a as $i) { foreach ($b as $j) { if ($j == 42) { break 2; } }}"
      ).should equal_ruby(
        "Php2Rb.foreach(a) { |i| Php2Rb.foreach(b) { |j| Php2Rb.break(2) if j == 42 } }"
      )
    end
  end

  it "should convert for loops" do
    php(
      "for( $i = 1; $i <= $toclevel; $i++ ) { echo($i); } ").
    should equal_ruby(
      "i = 1
       while i <= toclevel do
         print i
         i += 1
       end
      ")
  end

  it "should convert stupid for loops with commas" do
    php(
      "for ( ; $line !== false; $a->next(), $line = $a->current() ) { doIt(); }"
    ).should equal_ruby("
      line = a.current
      while line != false do
        a.next
        line = a.current
        doIt
      end
    ")
  end

  it "should convert a break statement without an argument" do
    php("break;").should equal_ruby("break")
  end

  it "should convert a break statement with an argument" do
    php("break 2;").should equal_ruby("Php2Rb.break 2")
  end

  it "should convert a continue statement that specifies an argument" do
    php("continue 2").should equal_ruby("Php2Rb.continue 2")
  end

  it "should convert global statements to calls to the runtime" do
    php("global $foo").should equal_ruby("php_global :foo")
  end

  it "should convert negative numbers" do
    php("-5").should equal_ruby("-5")
  end

  it "should convert negative floats" do
    php("-3.14").should equal_ruby("-3.14")
  end

  it "should support negativing variables" do
    php("-$x").should equal_ruby("-x")
  end

  it "should support negativing expressions" do
    php("-fooMeth($m[0][0])").should equal_ruby("-fooMeth(m[0][0])")
  end

  it "should convert while statements" do
    php("while($var) { echo('yes!'); }").should equal_ruby(
      "while var do
        print 'yes!'
      end")
  end

  it "should convert do-while statements" do
    php("do { foo(); bar(); } while($spam)").should equal_ruby(
    "loop { foo; bar; break unless spam }"
    )
  end

  it "should convert incrementing" do
    php("$i++").should equal_ruby("i += 1")
  end

  it "should convert incrementing (with pre-var syntax)" do
    php("++$i").should equal_ruby("i += 1")
  end

  it "should convert decrementing" do
    php("$i--").should equal_ruby("i -= 1")
  end

  it "should convert decrementing (with pre-var syntax)" do
    php("--$i").should equal_ruby("i -= 1")
  end

  it "should support decrementing with elements in an array" do
    php("--$piece['count']").should equal_ruby("piece['count'] -= 1")
  end

  it "should support incrementing on instance methods" do
    php("++$this->mAutonumber").should equal_ruby("@mAutonumber += 1")
  end


  # TODO: resolve semantic issues here?
  it "should convert === (strict equality)" do
    php("$a === $b").should equal_ruby("a == b")
  end

  it "should support getting characters out of strings" do
    php("$s{42}").should equal_ruby("s[42..42]")
  end

  it "should support getting characters out of strings with a var index" do
    php("$s{$i}").should equal_ruby("s[i..i]")
  end

  it "should support setting characters in a string" do
    php("$s{42} = 'x'").should equal_ruby("s[42..42] = 'x'")
  end

  it "shoulds support raising exceptions" do
    php(
      "throw new MWException( 'why am i programming in this awful language?' )").
    should equal_ruby(
      "raise MWException.new('why am i programming in this awful language?')")
  end

  it "should support initialization of objects" do
    php("$x = new Foo('arg1')").should equal_ruby("x = Foo.new('arg1')")
  end

  it "should convert string interpolation" do
    # yuck! oh well.
    php('"[[$m[1]\\1$m[2]|\\1]]"').should equal_ruby('("[[" + (m[1] + ("\001" + (m[2] + "|\001]]"))))')
  end

  it "should support ternarys" do
    php("$x = $cond ? $a : $b").should equal_ruby("x = cond ? a : b")
  end

  it "should convert appending to an array" do
    php("$stack[] = $val").should equal_ruby("stack << val")
  end

  it "should do something with refs, maybe." do
    php("function &getTitle() { return $title; }").should equal_ruby("def getTitle \n return title \n end")
  end

  it "should support casting to int" do
    php("(int)$var").should equal_ruby("var.to_i")
  end

  it "should cast to boolean using runtime" do
    php("(bool)$var").should equal_ruby("Php2Rb.to_bool(var)")
  end
  
  it "should support casting to array" do
    php("(array)$foo").should equal_ruby("foo.to_a")
  end

  it "should support assigning fields on an object" do
    php("$foo->mContainsOldMagic = true").should equal_ruby("foo.mContainsOldMagic = true")
  end

  it "should support getting fields on an object" do
    php("$foo->mContainsOldMagic").should equal_ruby("foo.mContainsOldMagic")
  end

  it "should support removing elements from a hash" do
    php("unset ( $elements[$k] )").should equal_ruby("elements.delete k")
  end

  it "should support removing instance variables by setting them to nil" do
    php("unset( $this->foo );").should equal_ruby("@foo = nil")
  end

  it "shoulds upport removing instance variables with an arbitrary key" do
    php("unset ($this->$name)").should equal_ruby('instance_variable_set(:"@#{name}", nil)')
  end

  it "should convert unpacking a list" do
    php(
      "list( $element, $content, $params, $tag ) = $data;"
    ).should equal_ruby(
      "element, content, params, tag = *data")
  end

  it "should convert class static method calls on self" do
    php(
      "class Foo { function bar() {self::createAssocArgs($args); } }").
    should equal_ruby(
      "class Foo \n def bar \n self.class.createAssocArgs(args) \n end \ end")
  end

  it "should convert class constant gets" do
    php(
      "class Foo { function bar() { return self::OT_HTML; } }").
    should equal_ruby(
      "class Foo; def bar; return self.class::OT_HTML; end; end")
  end

  it "should convert clone expression" do
    php("clone $t").should equal_ruby("t.dup")
  end

  it "should convert parameterized 'new'" do
    php("new $className( $arg )").should equal_ruby("Object.const_get(className).new(arg)")
  end

  it "should convert instanceof" do
    php("$wgTitle instanceof FakeTitle").should equal_ruby("wgTitle.is_a? FakeTitle")
  end

  it "should convert error supression into begin..rescue" do
    php("@doSomething()").should equal_ruby("begin \n doSomething \n rescue Exception \n end")
  end

  RESERVED_WORDS = ["begin", "end", "rescue"]
  RESERVED_WORDS_WITHOUT_METHODS = RESERVED_WORDS + ['do']
  describe "mangling reserved words" do
    RESERVED_WORDS_WITHOUT_METHODS.each do |kw|
      it "should mangle #{kw} in expressions" do
        php("$#{kw}").should equal_ruby("_#{kw}")
      end

      it "should mangle #{kw} in assignments" do
        php("$#{kw} = 2").should equal_ruby("_#{kw} = 2")
      end

      it "should mangle #{kw} in members of objects" do
        php("$thing->#{kw}").should equal_ruby("thing._#{kw}")
      end

      it "should mangle #{kw} in method definition" do
        php("function #{kw}() { echo('hello'); }").should equal_ruby("def _#{kw} \n print('hello') \n end")
      end
    end

    RESERVED_WORDS.each do |kw|
      it "should mangle #{kw} in method invocation" do
        php("#{kw}()").should equal_ruby("_#{kw}")
      end
    end

  end

  it "should mangle variables starting with upper case" do
    php("$PFreport = true").should equal_ruby("_PFreport = true")
  end

  it "should convert require_once" do
    php("require_once('includes/SkinTemplate.php')").should equal_ruby("require 'includes/SkinTemplate'")
  end
end