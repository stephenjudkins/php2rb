require File.dirname(__FILE__) + '/spec_helper'

describe Converter, " with flow control" do
  before do
    @converter = Converter.new
  end
  after do
    @converter = nil
  end
  it "converts a statement list" do
    xml = <<HERE
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
          <attr key="phc.line_number">2</attr>
        </attrs>
        <Token_int>
          <attrs>
            <attr key="phc.filename">test4.php</attr>
            <attr key="phc.line_number">2</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <value>1</value>
          <source_rep>1</source_rep>
        </Token_int>
      </AST_eval_expr>
      <AST_eval_expr>
        <attrs>
          <attr key="phc.comments">
          </attr>
          <attr key="phc.filename">test4.php</attr>
          <attr key="phc.line_number">3</attr>
        </attrs>
        <Token_int>
          <attrs>
            <attr key="phc.filename">test4.php</attr>
            <attr key="phc.line_number">3</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <value>2</value>
          <source_rep>2</source_rep>
        </Token_int>
      </AST_eval_expr>
    </AST_statement_list>
HERE
    @converter.eval(e(xml)).should == "1\n2"
  end
  
  it "converts a complex statement list" do
    xml = <<HERE
    <?xml version="1.0"?>
    <AST_statement_list>
      <attrs>
        <attr key="phc.comments"> </attr>
      </attrs>
      <AST_eval_expr>
        <attrs>
          <attr key="phc.comments"> </attr>
          <attr key="phc.filename">test3.php</attr>
          <attr key="phc.line_number">2</attr>
        </attrs>
        <AST_assignment>
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
              <attrs/>
              <value>%MAIN%</value>
            </Token_class_name>
            <Token_variable_name>
              <attrs/>
              <value>foo</value>
            </Token_variable_name>
            <AST_expr_list>
              <attrs/>
            </AST_expr_list>
            <AST_expr nil="true"/>
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
      </AST_eval_expr>
      <AST_if>
        <attrs>
          <attr key="phc.comments"> </attr>
          <attr key="phc.filename">test3.php</attr>
          <attr key="phc.line_number">3</attr>
          <attr key="phc.unparser.is_elseif">false</attr>
        </attrs>
        <AST_variable>
          <attrs>
            <attr key="phc.filename">test3.php</attr>
            <attr key="phc.line_number">3</attr>
            <attr key="phc.unparser.needs_brackets">false</attr>
          </attrs>
          <Token_class_name>
            <attrs/>
            <value>%MAIN%</value>
          </Token_class_name>
          <Token_variable_name>
            <attrs/>
            <value>foo</value>
          </Token_variable_name>
          <AST_expr_list>
            <attrs/>
          </AST_expr_list>
          <AST_expr nil="true"/>
        </AST_variable>
        <AST_statement_list>
          <attrs>
            <attr key="phc.comments"> </attr>
          </attrs>
          <AST_eval_expr>
            <attrs>
              <attr key="phc.comments"> </attr>
              <attr key="phc.filename">test3.php</attr>
              <attr key="phc.line_number">4</attr>
            </attrs>
            <AST_method_invocation>
              <attrs>
                <attr key="phc.filename">test3.php</attr>
                <attr key="phc.line_number">4</attr>
                <attr key="phc.unparser.needs_brackets">false</attr>
              </attrs>
              <Token_class_name>
                <attrs/>
                <value>%STDLIB%</value>
              </Token_class_name>
              <Token_method_name>
                <attrs/>
                <value>echo</value>
              </Token_method_name>
              <AST_actual_parameter_list>
                <attrs/>
                <AST_actual_parameter>
                  <attrs/>
                  <bool>false</bool>
                  <Token_string>
                    <attrs>
                      <attr key="phc.filename">test3.php</attr>
                      <attr key="phc.line_number">4</attr>
                      <attr key="phc.unparser.needs_brackets">true</attr>
                    </attrs>
                    <value>yes!</value>
                    <source_rep>yes!</source_rep>
                  </Token_string>
                </AST_actual_parameter>
              </AST_actual_parameter_list>
            </AST_method_invocation>
          </AST_eval_expr>
        </AST_statement_list>
        <AST_statement_list>
          <attrs>
            <attr key="phc.comments"> </attr>
          </attrs>
          <AST_eval_expr>
            <attrs>
              <attr key="phc.comments"> </attr>
              <attr key="phc.filename">test3.php</attr>
              <attr key="phc.line_number">6</attr>
            </attrs>
            <AST_method_invocation>
              <attrs>
                <attr key="phc.filename">test3.php</attr>
                <attr key="phc.line_number">6</attr>
                <attr key="phc.unparser.needs_brackets">false</attr>
              </attrs>
              <Token_class_name>
                <attrs/>
                <value>%STDLIB%</value>
              </Token_class_name>
              <Token_method_name>
                <attrs/>
                <value>echo</value>
              </Token_method_name>
              <AST_actual_parameter_list>
                <attrs/>
                <AST_actual_parameter>
                  <attrs/>
                  <bool>false</bool>
                  <Token_string>
                    <attrs>
                      <attr key="phc.filename">test3.php</attr>
                      <attr key="phc.line_number">6</attr>
                      <attr key="phc.unparser.needs_brackets">true</attr>
                    </attrs>
                    <value>no!</value>
                    <source_rep>no!</source_rep>
                  </Token_string>
                </AST_actual_parameter>
              </AST_actual_parameter_list>
            </AST_method_invocation>
          </AST_eval_expr>
        </AST_statement_list>
      </AST_if>
    </AST_statement_list>
HERE
    @converter.eval(e(xml)).should == 'foo = true
if foo
  print("yes!")
else
  print("no!")
end'

  end
  
  it "converts an if/else statement" do
    xml = <<HERE
    <AST_if xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance">
      <attrs>
        <attr key="phc.comments">
        </attr>
        <attr key="phc.filename">test3.php</attr>
        <attr key="phc.line_number">3</attr>
        <attr key="phc.unparser.is_elseif">false</attr>
      </attrs>
      <AST_variable>
        <attrs>
          <attr key="phc.filename">test3.php</attr>
          <attr key="phc.line_number">3</attr>
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
      <AST_statement_list>
        <attrs>
          <attr key="phc.comments">
          </attr>
        </attrs>
        <AST_eval_expr>
          <attrs>
            <attr key="phc.comments">
            </attr>
            <attr key="phc.filename">test3.php</attr>
            <attr key="phc.line_number">4</attr>
          </attrs>
          <AST_method_invocation>
            <attrs>
              <attr key="phc.filename">test3.php</attr>
              <attr key="phc.line_number">4</attr>
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
                    <attr key="phc.filename">test3.php</attr>
                    <attr key="phc.line_number">4</attr>
                    <attr key="phc.unparser.needs_brackets">true</attr>
                  </attrs>
                  <value>yes!</value>
                  <source_rep>yes!</source_rep>
                </Token_string>
              </AST_actual_parameter>
            </AST_actual_parameter_list>
          </AST_method_invocation>
        </AST_eval_expr>
      </AST_statement_list>
      <AST_statement_list>
        <attrs>
          <attr key="phc.comments">
          </attr>
        </attrs>
        <AST_eval_expr>
          <attrs>
            <attr key="phc.comments">
            </attr>
            <attr key="phc.filename">test3.php</attr>
            <attr key="phc.line_number">6</attr>
          </attrs>
          <AST_method_invocation>
            <attrs>
              <attr key="phc.filename">test3.php</attr>
              <attr key="phc.line_number">6</attr>
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
                    <attr key="phc.filename">test3.php</attr>
                    <attr key="phc.line_number">6</attr>
                    <attr key="phc.unparser.needs_brackets">true</attr>
                  </attrs>
                  <value>no!</value>
                  <source_rep>no!</source_rep>
                </Token_string>
              </AST_actual_parameter>
            </AST_actual_parameter_list>
          </AST_method_invocation>
        </AST_eval_expr>
      </AST_statement_list>
    </AST_if>
HERE
    @converter.eval(e(xml)).should == 'if foo
  print("yes!")
else
  print("no!")
end'
  end
  
  it "converts eval expressions" do
    xml = <<HERE
    <AST_eval_expr>
      <attrs>
        <attr key="phc.comments"> </attr>
        <attr key="phc.filename">test3.php</attr>
        <attr key="phc.line_number">4</attr>
      </attrs>
      <AST_method_invocation>
        <attrs>
          <attr key="phc.filename">test3.php</attr>
          <attr key="phc.line_number">4</attr>
          <attr key="phc.unparser.needs_brackets">false</attr>
        </attrs>
        <Token_class_name>
          <attrs/>
          <value>%STDLIB%</value>
        </Token_class_name>
        <Token_method_name>
          <attrs/>
          <value>foo_method</value>
        </Token_method_name>
        <AST_actual_parameter_list>
          <attrs/>
          <AST_actual_parameter>
            <attrs/>
            <bool>false</bool>
            <Token_string>
              <attrs>
                <attr key="phc.filename">test3.php</attr>
                <attr key="phc.line_number">4</attr>
                <attr key="phc.unparser.needs_brackets">true</attr>
              </attrs>
              <value>yes!</value>
              <source_rep>yes!</source_rep>
            </Token_string>
          </AST_actual_parameter>
        </AST_actual_parameter_list>
      </AST_method_invocation>
    </AST_eval_expr>
HERE
    @converter.eval(e(xml)).should == 'foo_method("yes!")'
  end

end