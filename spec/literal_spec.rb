require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " converting literals" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  
  it "converts booleans" do
    true_xml = <<HERE
    <Token_bool>
			<attrs>
				<attr key="phc.filename">test2.php</attr>
				<attr key="phc.line_number">6</attr>
				<attr key="phc.unparser.needs_brackets">false</attr>
			</attrs>
			<value>True</value>
			<source_rep>true</source_rep>
		</Token_bool>
HERE

    false_xml = <<HERE
    <Token_bool>
			<attrs>
				<attr key="phc.filename">test2.php</attr>
				<attr key="phc.line_number">6</attr>
				<attr key="phc.unparser.needs_brackets">false</attr>
			</attrs>
			<value>False</value>
			<source_rep>false</source_rep>
		</Token_bool>
HERE

    @converter.eval(e(true_xml)).should == 'true'
    @converter.eval(e(false_xml)).should == 'false'
  end
  
  it "converts strings" do
    xml = <<HERE
    <Token_string>
      <attrs>
        <attr key="phc.filename">test.php</attr>
        <attr key="phc.line_number">2</attr>
        <attr key="phc.unparser.needs_brackets">false</attr>
      </attrs>
      <value>hello world</value>
      <source_rep>hello world</source_rep>
    </Token_string>
HERE
    @converter.eval(e(xml)).should == '"hello world"'
  end

  it "converts integers" do
    xml = <<HERE
    <Token_int>
			<attrs>
				<attr key="phc.filename">test2.php</attr>
				<attr key="phc.line_number">3</attr>
				<attr key="phc.unparser.needs_brackets">false</attr>
			</attrs>
			<value>3</value>
			<source_rep>3</source_rep>
		</Token_int>
HERE
    @converter.eval(e(xml)).should == '3'
  end
  
  it "converts floats" do
    xml = <<HERE
    <Token_real>
			<attrs>
				<attr key="phc.filename">test2.php</attr>
				<attr key="phc.line_number">10</attr>
				<attr key="phc.unparser.needs_brackets">false</attr>
			</attrs>
			<value>2.4199999999999999289</value>
			<source_rep>2.42</source_rep>
		</Token_real>
HERE
    @converter.eval(e(xml)).should == '2.42'
  end

  it "converts null" do
    xml = <<HERE 
    <Token_null>
			<attrs>
				<attr key="phc.filename">test2.php</attr>
				<attr key="phc.line_number">3</attr>
				<attr key="phc.unparser.needs_brackets">false</attr>
			</attrs>
			<source_rep>null</source_rep>
		</Token_null>
HERE
    @converter.eval(e(xml)).should == 'nil'
  end

end