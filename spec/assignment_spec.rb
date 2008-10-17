require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " assigning variables" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  
  it "converts assignments" do
    xml = <<HERE
    <AST_assignment xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <attrs>
        <attr key="phc.filename">test3.php</attr>
        <attr key="phc.line_number">2</attr>
        <attr key="phc.unparser.is_global_stmt">false</attr>
        <attr key="phc.unparser.needs_brackets">false</attr>
      </attrs>
      <AST_variable>
        <attrs>
          <attr key="phc.filename">test3.php</attr>
          <attr key="phc.line_number">2</attr>
          <attr key="phc.unparser.needs_brackets">false</attr>
        </attrs>
        <Token_class_name>
          <attrs />
          <value>%MAIN%</value>
        </Token_class_name>
        <Token_variable_name>
          <attrs />
          <value>foo</value>
        </Token_variable_name>
        <AST_expr_list>
          <attrs />
        </AST_expr_list>
        <AST_expr xsi:nil="true" />
      </AST_variable>
      <bool>false</bool>
      <Token_bool>
        <attrs>
          <attr key="phc.filename">test3.php</attr>
          <attr key="phc.line_number">2</attr>
          <attr key="phc.unparser.needs_brackets">false</attr>
        </attrs>
        <value>True</value>
        <source_rep>true</source_rep>
      </Token_bool>
    </AST_assignment>
HERE
    @converter.eval(e(xml)).should == 'foo = true'
  end
end