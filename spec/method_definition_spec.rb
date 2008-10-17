require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " with method definitions" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end

  it "defines simple methods" do
    xml = <<HERE
    <AST_method xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <attrs>
        <attr key="phc.comments">
        </attr>
        <attr key="phc.filename">test4.php</attr>
        <attr key="phc.line_number">2</attr>
      </attrs>
      <AST_signature>
        <attrs>
          <attr key="phc.filename">test4.php</attr>
          <attr key="phc.line_number">4</attr>
        </attrs>
        <AST_method_mod>
          <attrs />
          <bool>false</bool>
          <bool>false</bool>
          <bool>false</bool>
          <bool>true</bool>
          <bool>false</bool>
          <bool>false</bool>
        </AST_method_mod>
        <bool>false</bool>
        <Token_method_name>
          <attrs />
          <value>foo</value>
        </Token_method_name>
        <AST_formal_parameter_list>
          <attrs />
          <AST_formal_parameter>
            <attrs>
              <attr key="phc.filename">test4.php</attr>
              <attr key="phc.line_number">2</attr>
            </attrs>
            <AST_type>
              <attrs>
                <attr key="phc.filename">test4.php</attr>
                <attr key="phc.line_number">2</attr>
              </attrs>
              <bool>false</bool>
              <Token_class_name xsi:nil="true" />
            </AST_type>
            <bool>false</bool>
            <Token_variable_name>
              <attrs />
              <value>bar</value>
            </Token_variable_name>
            <AST_expr xsi:nil="true" />
          </AST_formal_parameter>
        </AST_formal_parameter_list>
      </AST_signature>
      <AST_statement_list>
        <attrs>
          <attr key="phc.comments">
          </attr>
        </attrs>
        <AST_eval_expr>
          <attrs>
            <attr key="phc.comments">
            </attr>
            <attr key="phc.filename">test4.php</attr>
            <attr key="phc.line_number">3</attr>
          </attrs>
          <AST_method_invocation>
            <attrs>
              <attr key="phc.filename">test4.php</attr>
              <attr key="phc.line_number">3</attr>
              <attr key="phc.unparser.needs_brackets">false</attr>
            </attrs>
            <Token_class_name>
              <attrs />
              <value>%STDLIB%</value>
            </Token_class_name>
            <Token_method_name>
              <attrs />
              <value>echo</value>
            </Token_method_name>
            <AST_actual_parameter_list>
              <attrs />
              <AST_actual_parameter>
                <attrs />
                <bool>false</bool>
                <AST_bin_op>
                  <attrs>
                    <attr key="phc.filename">test4.php</attr>
                    <attr key="phc.line_number">3</attr>
                    <attr key="phc.unparser.needs_brackets">true</attr>
                  </attrs>
                  <AST_variable>
                    <attrs>
                      <attr key="phc.filename">test4.php</attr>
                      <attr key="phc.line_number">3</attr>
                      <attr key="phc.unparser.needs_brackets">false</attr>
                    </attrs>
                    <AST_target xsi:nil="true" />
                    <Token_variable_name>
                      <attrs />
                      <value>bar</value>
                    </Token_variable_name>
                    <AST_expr_list>
                      <attrs />
                    </AST_expr_list>
                    <AST_expr xsi:nil="true" />
                  </AST_variable>
                  <Token_op>
                    <attrs />
                    <value>+</value>
                  </Token_op>
                  <Token_int>
                    <attrs>
                      <attr key="phc.filename">test4.php</attr>
                      <attr key="phc.line_number">3</attr>
                      <attr key="phc.unparser.needs_brackets">false</attr>
                    </attrs>
                    <value>1</value>
                    <source_rep>1</source_rep>
                  </Token_int>
                </AST_bin_op>
              </AST_actual_parameter>
            </AST_actual_parameter_list>
          </AST_method_invocation>
        </AST_eval_expr>
      </AST_statement_list>
    </AST_method>
HERE
    @converter.eval(e(xml)).should == 'def foo(bar)
print(bar + 1)
end'
  end

  it "with parameter list" do
    xml = <<HERE
		<AST_formal_parameter_list xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<attrs />
			<AST_formal_parameter>
				<attrs>
					<attr key="phc.filename">test4.php</attr>
					<attr key="phc.line_number">2</attr>
				</attrs>
				<AST_type>
					<attrs>
						<attr key="phc.filename">test4.php</attr>
						<attr key="phc.line_number">2</attr>
					</attrs>
					<bool>false</bool>
					<Token_class_name xsi:nil="true" />
				</AST_type>
				<bool>false</bool>
				<Token_variable_name>
					<attrs />
					<value>bar</value>
				</Token_variable_name>
				<AST_expr xsi:nil="true" />
			</AST_formal_parameter>
		</AST_formal_parameter_list>
HERE
    @converter.eval(e(xml)).should == "bar"
  end
  
  it "with no parameters" do
    xml = <<HERE
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
        <AST_method_invocation>
          <attrs>
            <attr key="phc.filename">test.php</attr>
            <attr key="phc.line_number">2</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <Token_class_name>
            <attrs />
            <value>%STDLIB%</value>
          </Token_class_name>
          <Token_method_name>
            <attrs />
            <value>echo</value>
          </Token_method_name>
          <AST_actual_parameter_list>
            <attrs />
            <AST_actual_parameter>
              <attrs />
              <bool>false</bool>
              <Token_string>
                <attrs>
                  <attr key="phc.filename">test.php</attr>
                  <attr key="phc.line_number">2</attr>
                  <attr key="phc.unparser.needs_brackets">true</attr>
                </attrs>
                <value>spam</value>
                <source_rep>spam</source_rep>
              </Token_string>
            </AST_actual_parameter>
          </AST_actual_parameter_list>
        </AST_method_invocation>
			</AST_statement_list>
		</AST_method>
HERE
    @converter.eval(e(xml)).should == 'def eggs()
print("spam")
end'
  end
  
  it "with return" do
    xml = <<HERE
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
HERE
    @converter.eval(e(xml)).should == 'return "blah"'
  end

end