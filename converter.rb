require 'rexml/document'
require 'base64'
# processes XML output by PHC 0.1.7 @ http://www.phpcompiler.org/src/archive/phc-0.1.7.tar.bz2
class Converter
  include REXML
  METHOD_NAME_MAP = {
    "%STDLIB%" => {
      "echo" => "puts"
    },
  }
  def php_method(node)
    class_name = val(node.elements['Token_class_name'])
    method_name = val(node.elements['Token_method_name'])

    ruby_method_name = (METHOD_NAME_MAP[class_name] || {})[method_name] || method_name
    arguments_node = node.elements['AST_actual_parameter_list']
    arguments = arguments_node ? arguments(arguments_node): []
    return "#{ruby_method_name}(#{arguments.join ", "})"
  end

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
    case node.name
    when 'Token_bool'
      return boolean(node)
    when 'Token_string'
      return string(node)
    when 'Token_int'
      return integer(node)
    when 'Token_real'
      return float(node)
    when 'Token_null'
      return 'nil'
    when 'AST_method_invocation'
      return php_method(node)
    when 'AST_assignment'
      return assignment(node)
    when 'AST_variable'
      return variable(node)
    when 'AST_statement_list'
      return statement_list(node)
    when 'AST_if'
      return php_if(node)
    when 'AST_bin_op'
      return comparison(node)
    when 'Token_op'
      return val(node)
    end
  end

  def string(node)
    return val(node).to_s.inspect
  end

  def boolean(node)
    return (val(node).to_s == 'True').to_s
  end

  def integer(node)
    return val(node).to_i.to_s
  end

  def float(node)
    node.elements['source_rep'].text.to_s
  end

  def assignment(node)
    var, val = strip_useless_nodes(node.children).collect {|n| eval(n)}
    return "#{var} = #{val}"
  end

  def variable(node)
    return val(XPath.match(node, 'Token_variable_name').first)
  end

  def statement_list(node)
    statements = XPath.match(node, 'AST_eval_expr').collect do |n|
      eval(strip_useless_nodes(n.children).first)
    end
    return statements.join("\n")
  end

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
  
  def comparison(node)
    first, operator, second = strip_useless_nodes(node.children)
    return "#{eval(first)} #{eval(operator)} #{eval(second)}"
  end
end 