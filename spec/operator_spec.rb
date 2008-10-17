require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " converting comparisons" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  it " converts equality" do
    xml = <<HERE
    <AST_bin_op xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
			<attrs>
				<attr key="phc.filename">test4.php</attr>
				<attr key="phc.line_number">2</attr>
				<attr key="phc.unparser.needs_brackets">false</attr>
			</attrs>
			<AST_variable>
				<attrs>
					<attr key="phc.filename">test4.php</attr>
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
			<Token_op>
				<attrs />
				<value>==</value>
			</Token_op>
			<Token_int>
				<attrs>
					<attr key="phc.filename">test4.php</attr>
					<attr key="phc.line_number">2</attr>
					<attr key="phc.unparser.needs_brackets">false</attr>
				</attrs>
				<value>2</value>
				<source_rep>2</source_rep>
			</Token_int>
		</AST_bin_op>
HERE
    @converter.eval(e(xml)).should == 'foo == 2'
  end

  it "converts < tokens" do
    xml = <<HERE
    <Token_op>
			<attrs />
			<value encoding="base64">PA==</value>
		</Token_op>
HERE
    @converter.eval(e(xml)).should== '<'
  end
  
  it "with expressions needing parentheses" do
    xml = <<HERE
    <AST_bin_op>
			<attrs>
				<attr key="phc.filename">test.php</attr>
				<attr key="phc.line_number">2</attr>
				<attr key="phc.unparser.needs_brackets">true</attr>
			</attrs>
			<AST_bin_op>
				<attrs>
					<attr key="phc.filename">test.php</attr>
					<attr key="phc.line_number">2</attr>
					<attr key="phc.unparser.needs_brackets">false</attr>
				</attrs>
				<Token_int>
					<attrs>
						<attr key="phc.filename">test.php</attr>
						<attr key="phc.line_number">2</attr>
						<attr key="phc.unparser.needs_brackets">false</attr>
					</attrs>
					<value>1</value>
					<source_rep>1</source_rep>
				</Token_int>
				<Token_op>
					<attrs />
					<value>+</value>
				</Token_op>
				<AST_bin_op>
					<attrs>
						<attr key="phc.filename">test.php</attr>
						<attr key="phc.line_number">2</attr>
						<attr key="phc.unparser.needs_brackets">true</attr>
					</attrs>
					<Token_int>
						<attrs>
							<attr key="phc.filename">test.php</attr>
							<attr key="phc.line_number">2</attr>
							<attr key="phc.unparser.needs_brackets">false</attr>
						</attrs>
						<value>5</value>
						<source_rep>5</source_rep>
					</Token_int>
					<Token_op>
						<attrs />
						<value>*</value>
					</Token_op>
					<Token_int>
						<attrs>
							<attr key="phc.filename">test.php</attr>
							<attr key="phc.line_number">2</attr>
							<attr key="phc.unparser.needs_brackets">false</attr>
						</attrs>
						<value>35</value>
						<source_rep>35</source_rep>
					</Token_int>
				</AST_bin_op>
			</AST_bin_op>
			<Token_op>
				<attrs />
				<value>+</value>
			</Token_op>
			<AST_bin_op>
				<attrs>
					<attr key="phc.filename">test.php</attr>
					<attr key="phc.line_number">2</attr>
					<attr key="phc.unparser.needs_brackets">true</attr>
				</attrs>
				<Token_int>
					<attrs>
						<attr key="phc.filename">test.php</attr>
						<attr key="phc.line_number">2</attr>
						<attr key="phc.unparser.needs_brackets">false</attr>
					</attrs>
					<value>2</value>
					<source_rep>2</source_rep>
				</Token_int>
				<Token_op>
					<attrs />
					<value>*</value>
				</Token_op>
				<Token_int>
					<attrs>
						<attr key="phc.filename">test.php</attr>
						<attr key="phc.line_number">2</attr>
						<attr key="phc.unparser.needs_brackets">false</attr>
					</attrs>
					<value>5</value>
					<source_rep>5</source_rep>
				</Token_int>
			</AST_bin_op>
		</AST_bin_op>
HERE
    @converter.eval(e(xml)).should == "(1 + (5 * 35) + (2 * 5))"
  end
end
