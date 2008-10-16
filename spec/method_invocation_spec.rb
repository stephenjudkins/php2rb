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
    @converter.arguments(e(xml)).should == ['1','"foo"', '3.14', 'true', 'nil']
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
end