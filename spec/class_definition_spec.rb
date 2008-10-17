require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " defining classes" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  
  it "simple classes" do
    xml = <<HERE
<AST_class_def xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
  <attrs>
    <attr key="phc.comments">
    </attr>
    <attr key="phc.filename">test4.php</attr>
    <attr key="phc.line_number">2</attr>
  </attrs>
  <AST_class_mod>
    <attrs>
      <attr key="phc.filename">test4.php</attr>
      <attr key="phc.line_number">2</attr>
    </attrs>
    <bool>false</bool>
    <bool>false</bool>
  </AST_class_mod>
  <Token_class_name>
    <attrs />
    <value>Spam</value>
  </Token_class_name>
  <Token_class_name xsi:nil="true" />
  <Token_interface_name_list>
    <attrs />
  </Token_interface_name_list>
  <AST_member_list>
    <attrs>
      <attr key="phc.comments">
      </attr>
    </attrs>
    <AST_method>
      <attrs>
        <attr key="phc.comments">
        </attr>
        <attr key="phc.filename">test4.php</attr>
        <attr key="phc.line_number">3</attr>
      </attrs>
      <AST_signature>
        <attrs>
          <attr key="phc.filename">test4.php</attr>
          <attr key="phc.line_number">5</attr>
        </attrs>
        <AST_method_mod>
          <attrs />
          <bool>true</bool>
          <bool>false</bool>
          <bool>false</bool>
          <bool>false</bool>
          <bool>false</bool>
          <bool>false</bool>
        </AST_method_mod>
        <bool>false</bool>
        <Token_method_name>
          <attrs />
          <value>eggs</value>
        </Token_method_name>
        <AST_formal_parameter_list>
          <attrs />
        </AST_formal_parameter_list>
      </AST_signature>
      <AST_statement_list>
        <attrs>
          <attr key="phc.comments">
          </attr>
        </attrs>
        <AST_return>
          <attrs>
            <attr key="phc.comments">
            </attr>
            <attr key="phc.filename">test4.php</attr>
            <attr key="phc.line_number">4</attr>
          </attrs>
          <Token_string>
            <attrs>
              <attr key="phc.filename">test4.php</attr>
              <attr key="phc.line_number">4</attr>
              <attr key="phc.unparser.needs_brackets">false</attr>
            </attrs>
            <value>blah</value>
            <source_rep>blah</source_rep>
          </Token_string>
        </AST_return>
      </AST_statement_list>
    </AST_method>
  </AST_member_list>
</AST_class_def>
HERE
  @converter.eval(e(xml)).should == 'class Spam
  def eggs()
    return "blah"
  end
end'
 end
end
