require 'rexml/document'
require 'base64'

# processes XML output by PHC 0.1.7 @ http://www.phpcompiler.org/src/archive/phc-0.1.7.tar.bz2
class Converter
  class << self
    attr_reader :token_map
    def token(token, method)
      @token_map ||= {}
      @token_map[token] = method
    end
  end
  include REXML
  METHOD_NAME_MAP = {
    "%STDLIB%" => {
      "echo" => "print"
    },
  }
  def convert(xml)
    return eval(Document.new(xml).root)
  end
  
  token 'AST_method_invocation', :php_method
  def php_method(node)
    class_name = val(node.elements['Token_class_name'])
    method_name = val(node.elements['Token_method_name'])

    ruby_method_name = (METHOD_NAME_MAP[class_name] || {})[method_name] || method_name
    arguments_node = node.elements['AST_actual_parameter_list']
    arguments = arguments_node ? arguments(arguments_node): []
    return "#{ruby_method_name}(#{arguments.join ", "})"
  end

  token 'Token_op', :val
  def val(node)
    val_node = node.elements['value']
    text = val_node.text
    return val_node.attributes['encoding'] == 'base64' ? Base64.decode64(text) : text
  end

  def arguments(node)
    out = XPath.match(node, 'AST_actual_parameter').collect do |param|
      eval(strip_useless_nodes(param.children).first)
    end
  end

  def strip_useless_nodes(nodes)
    nodes.select {|n| n.is_a?(Element) and !['attrs', 'bool'].include?(n.name)}
  end

  def eval(node)
    method_name = self.class.token_map[node.name]
    return send(method_name, node) if method_name
  end

  token 'Token_null', :php_null
  def php_null(token)
    return 'nil'
  end

  token 'Token_string', :string
  def string(node)
    return val(node).to_s.inspect
  end
  
  token 'Token_bool', :boolean
  def boolean(node)
    return (val(node).to_s == 'True').to_s
  end

  token 'Token_int', :integer
  def integer(node)
    return val(node).to_i.to_s
  end

  token 'Token_real', :float
  def float(node)
    node.elements['source_rep'].text.to_s
  end

  token 'AST_assignment', :assignment
  def assignment(node)
    var, val = strip_useless_nodes(node.children).collect {|n| eval(n)}
    return "#{var} = #{val}"
  end

  token 'AST_variable', :variable
  def variable(node)
    return val(XPath.match(node, 'Token_variable_name').first)
  end

  token 'AST_statement_list', :statement_list
  def statement_list(node)
    statements = strip_useless_nodes(node.children).collect {|n| eval(n)}
    return statements.join("\n")
  end

  token 'AST_if', :php_if
  def php_if(node)
    out = []
    condition, if_statement, else_statement = strip_useless_nodes(node.children)
    out << "if #{eval condition}"
    out << eval(if_statement)
    if else_statement
      out << "else"
      out << eval(else_statement)
    end
    out << "end"
    return out.join("\n")
  end

  token 'AST_bin_op', :comparison
  def comparison(node)
    first, operator, second = strip_useless_nodes(node.children)
    return "#{eval(first)} #{eval(operator)} #{eval(second)}"
  end

  token 'AST_php_script', :script
  def script(node)
    statement_list = XPath.match(node, 'AST_class_def_list/AST_class_def/AST_member_list/AST_method[1]/AST_statement_list').first
    
    return eval(statement_list)
  end
  
  token 'AST_eval_expr', :eval_expression
  def eval_expression(node)
    nodes = strip_useless_nodes(node.children).collect {|n| eval(n)}
    return nodes.join("\n")
  end
  
end 