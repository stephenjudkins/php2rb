require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " with method invocations" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  
  it "should convert 'echo' to 'print'" do
    xml = <<HERE
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
            <value>hello world</value>
            <source_rep>hello world</source_rep>
          </Token_string>
        </AST_actual_parameter>
      </AST_actual_parameter_list>
    </AST_method_invocation>
HERE
    @converter.eval(e(xml)).should == 'print("hello world")'
  end

  it "should parse arguments" do
    xml = <<HERE
    <AST_actual_parameter_list>
      <attrs />
      <AST_actual_parameter>
        <attrs>
          <attr key="phc.filename">test2.php</attr>
          <attr key="phc.line_number">3</attr>
        </attrs>
        <bool>false</bool>
        <Token_int>
          <attrs>
            <attr key="phc.filename">test2.php</attr>
            <attr key="phc.line_number">3</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <value>1</value>
          <source_rep>1</source_rep>
        </Token_int>
      </AST_actual_parameter>
      <AST_actual_parameter>
        <attrs>
          <attr key="phc.filename">test2.php</attr>
          <attr key="phc.line_number">3</attr>
        </attrs>
        <bool>false</bool>
        <Token_string>
          <attrs>
            <attr key="phc.filename">test2.php</attr>
            <attr key="phc.line_number">3</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <value>foo</value>
          <source_rep>foo</source_rep>
        </Token_string>
      </AST_actual_parameter>
      <AST_actual_parameter>
        <attrs>
          <attr key="phc.filename">test2.php</attr>
          <attr key="phc.line_number">3</attr>
        </attrs>
        <bool>false</bool>
        <Token_real>
          <attrs>
            <attr key="phc.filename">test2.php</attr>
            <attr key="phc.line_number">3</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <value>3.1400000000000001243</value>
          <source_rep>3.14</source_rep>
        </Token_real>
      </AST_actual_parameter>
      <AST_actual_parameter>
        <attrs>
          <attr key="phc.filename">test2.php</attr>
          <attr key="phc.line_number">3</attr>
        </attrs>
        <bool>false</bool>
        <Token_bool>
          <attrs>
            <attr key="phc.filename">test2.php</attr>
            <attr key="phc.line_number">3</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <value>True</value>
          <source_rep>true</source_rep>
        </Token_bool>
      </AST_actual_parameter>
      <AST_actual_parameter>
        <attrs>
          <attr key="phc.filename">test2.php</attr>
          <attr key="phc.line_number">3</attr>
        </attrs>
        <bool>false</bool>
        <Token_null>
          <attrs>
            <attr key="phc.filename">test2.php</attr>
            <attr key="phc.line_number">3</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <source_rep>null</source_rep>
        </Token_null>
      </AST_actual_parameter>
    </AST_actual_parameter_list>
HERE
    @converter.eval(e(xml)).should == '1, "foo", 3.14, true, nil'
  end
  
  it "converts nested function calls" do
    xml = <<HERE
    <AST_method_invocation>
      <attrs>
        <attr key="phc.filename">test2.php</attr>
        <attr key="phc.line_number">6</attr>
        <attr key="phc.unparser.needs_brackets">false</attr>
      </attrs>
      <Token_class_name>
        <attrs />
        <value>%STDLIB%</value>
      </Token_class_name>
      <Token_method_name>
        <attrs />
        <value>foo_method</value>
      </Token_method_name>
      <AST_actual_parameter_list>
        <attrs />
        <AST_actual_parameter>
          <attrs>
            <attr key="phc.filename">test2.php</attr>
            <attr key="phc.line_number">6</attr>
          </attrs>
          <bool>false</bool>
          <AST_method_invocation>
            <attrs>
              <attr key="phc.filename">test2.php</attr>
              <attr key="phc.line_number">6</attr>
              <attr key="phc.unparser.needs_brackets">false</attr>
            </attrs>
            <Token_class_name>
              <attrs />
              <value>%STDLIB%</value>
            </Token_class_name>
            <Token_method_name>
              <attrs />
              <value>bar_method</value>
            </Token_method_name>
            <AST_actual_parameter_list>
              <attrs />
              <AST_actual_parameter>
                <attrs>
                  <attr key="phc.filename">test2.php</attr>
                  <attr key="phc.line_number">6</attr>
                </attrs>
                <bool>false</bool>
                <Token_bool>
                  <attrs>
                    <attr key="phc.filename">test2.php</attr>
                    <attr key="phc.line_number">6</attr>
                    <attr key="phc.unparser.needs_brackets">false</attr>
                  </attrs>
                  <value>True</value>
                  <source_rep>true</source_rep>
                </Token_bool>
              </AST_actual_parameter>
            </AST_actual_parameter_list>
          </AST_method_invocation>
        </AST_actual_parameter>
      </AST_actual_parameter_list>
    </AST_method_invocation>
HERE
    # foo_method(bar_method(true));
    @converter.eval(e(xml)).should == 'foo_method(bar_method(true))'
  end
  it "with methods of object instances" do
    xml = <<HERE
    <AST_method_invocation xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <attrs>
        <attr key="phc.filename">test2.php</attr>
        <attr key="phc.line_number">4</attr>
        <attr key="phc.unparser.needs_brackets">false</attr>
      </attrs>
      <AST_variable>
        <attrs>
          <attr key="phc.filename">test2.php</attr>
          <attr key="phc.line_number">4</attr>
          <attr key="phc.unparser.needs_brackets">false</attr>
        </attrs>
        <Token_class_name>
          <attrs />
          <value>%MAIN%</value>
        </Token_class_name>
        <Token_variable_name>
          <attrs />
          <value>spam</value>
        </Token_variable_name>
        <AST_expr_list>
          <attrs />
        </AST_expr_list>
        <AST_expr xsi:nil="true" />
      </AST_variable>
      <Token_method_name>
        <attrs>
          <attr key="phc.filename">test2.php</attr>
          <attr key="phc.line_number">4</attr>
        </attrs>
        <value>eggs</value>
      </Token_method_name>
      <AST_actual_parameter_list>
        <attrs />
        <AST_actual_parameter>
          <attrs>
            <attr key="phc.filename">test2.php</attr>
            <attr key="phc.line_number">4</attr>
          </attrs>
          <bool>false</bool>
          <Token_bool>
            <attrs>
              <attr key="phc.filename">test2.php</attr>
              <attr key="phc.line_number">4</attr>
              <attr key="phc.unparser.needs_brackets">false</attr>
            </attrs>
            <value>True</value>
            <source_rep>true</source_rep>
          </Token_bool>
        </AST_actual_parameter>
      </AST_actual_parameter_list>
    </AST_method_invocation>
HERE
    @converter.eval(e(xml)).should == 'spam.eggs(true)'
  end
  it "with class method invocation" do
    xml = <<HERE
    <AST_method_invocation>
			<attrs>
				<attr key="phc.filename">test2.php</attr>
				<attr key="phc.line_number">5</attr>
				<attr key="phc.unparser.needs_brackets">false</attr>
			</attrs>
			<Token_class_name>
				<attrs />
				<value>SpamClass</value>
			</Token_class_name>
			<Token_method_name>
				<attrs />
				<value>eggs</value>
			</Token_method_name>
			<AST_actual_parameter_list>
				<attrs />
				<AST_actual_parameter>
					<attrs>
						<attr key="phc.filename">test2.php</attr>
						<attr key="phc.line_number">5</attr>
					</attrs>
					<bool>false</bool>
					<Token_bool>
						<attrs>
							<attr key="phc.filename">test2.php</attr>
							<attr key="phc.line_number">5</attr>
							<attr key="phc.unparser.needs_brackets">false</attr>
						</attrs>
						<value>True</value>
						<source_rep>true</source_rep>
					</Token_bool>
				</AST_actual_parameter>
			</AST_actual_parameter_list>
		</AST_method_invocation>
HERE
    @converter.eval(e(xml)).should == "SpamClass.eggs(true)"
  end
end