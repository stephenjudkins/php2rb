require 'java_libs'
require 'string_extensions'

require 'rubygems'
require 'ruby_parser'
require 'ruby2ruby'


class Java::ComCauchoQuercusProgram::EchoStatement
  field_reader :_expr => :expr
end

class Java::ComCauchoQuercusExpr::BinaryExpr
  field_reader :_left => :left, :_right => :right
end

class Java::ComCauchoQuercusExpr::AssignExpr
  field_reader :_var => :var, :_value => :value
end

class Java::ComCauchoQuercusExpr::StringLiteralExpr
  field_reader :_value => :value
end

class Java::ComCauchoQuercusExpr::FunctionExpr
  field_reader :_args => :args
end

class Java::ComCauchoQuercusProgram::TextStatement
  field_reader :_value => :value
end

class Java::ComCauchoQuercusProgram::Function
  field_reader :_statement => :statement
end

class Java::ComCauchoQuercusProgram::ReturnStatement
  field_reader :_expr => :expr
end

module Php2Rb

class Converter

  class << self
    def convert(string)
      quercus = com.caucho.quercus.Quercus.new
      path = com.caucho.vfs.NullPath::NULL
      read_stream = com.caucho.vfs.StringReader.open string

      parser = com.caucho.quercus.parser.QuercusParser.new quercus, path, read_stream

      program = parser.parse

      functions = functions(program)

      return s(:block, *(functions(program) + [p(program.statement)]).compact )
    end


    def functions(program)
      program.functions.collect {|f| p(f) }
    end

    def node_type(node)
      node.java_class.name.split(".").last.snake_case.to_sym
    end

    def p(node)
      send node_type(node), node
    end

    def method_missing(method, node)
      "called #{method} for #{node.java_class.name}"
    end

    def echo_statement(node)
      s(:call, nil, :print, s(:arglist, p(node.expr)))
    end

    def add_expr(node)
      binary_expr node, :+
    end

    def sub_expr(node)
      binary_expr node, :-
    end

    def mul_expr(node)
      binary_expr node, :*
    end

    def div_expr(node)
      binary_expr node, :/
    end

    def gt_expr(node)
      binary_expr node, :>
    end

    def lt_expr(node)
      binary_expr node, :<
    end

    def binary_expr(node, operator)
      s(:call, p(node.left), operator, s(:arglist, p(node.right)))
    end

    def literal_expr(node)
      s(:lit, p(node.value))
    end

    def long_value(node)
      node.to_long
    end

    def double_value(node)
      node.toJavaObject
    end

    def const_expr(node)
      s(:call, nil, node.var.to_sym, s(:arglist))
    end

    def var_expr(node)
      s(:call, nil, node.name.to_sym, s(:arglist))
    end

    def expr_statement(node)
      p(node.expr)
    end

    def assign_expr(node)
      s(:lasgn, node.var.name.to_sym, p(node.value))
    end

    def eq_expr(node)
      s(:call, p(node.left), :==, s(:arglist, p(node.right)))
    end

    def if_statement(node)
      s(:if,
        p(node.test),
        p(node.true_block),
        p(node.false_block)
      )
    end

    def string_literal_expr(node)
      s(:str, node.value.value)
    end

    def text_statement(node)
      s(:call, nil, :print, s(:arglist, s(:str, node.value)))
    end

    def block_statement(node)
      return nil if node.statements.length == 0
      s(:block, *node.statements.collect {|node| p(node)})
    end

    def function(node)
      s(:defn,
        node.name.to_sym,
        s(:args, *node.args.inject([]) {|m, arg| m += p(arg); m } ),
        s(:scope, s(:block, p(node.statement)))
      )
    end

    def arg(node)
      name = node.name.to_sym
      return [name] if node_type(node.default) == :required_expr
      return [name, s(:block, s(:lasgn, name, p(node.default)))]
    end

    def return_statement(node)
      s(:return, p(node.expr))
    end

    def function_expr(node)
      s(:call, nil, node.name.to_sym, s(:arglist, *node.args.collect {|a| p(a) }) )
    end
  end
end

end #Php2Rb