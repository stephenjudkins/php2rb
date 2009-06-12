require 'java_libs'
require 'string_extensions'
require 'open_quercus_classes'

require 'rubygems'
require 'ruby_parser'
require 'ruby2ruby'

require 'converter/control_flow'
require 'converter/basic_expressions'
require 'converter/operators'
require 'converter/literals'
require 'converter/methods'
require 'converter/classes'

module Php2Rb

class Converter

  class << self
    include ControlFlow
    include BasicExpressions
    include Operators
    include Literals
    include Methods
    include Classes

    attr_accessor :debug

    def convert(string)
      quercus = com.caucho.quercus.Quercus.new
      path = com.caucho.vfs.NullPath::NULL
      read_stream = com.caucho.vfs.StringReader.open string

      parser = com.caucho.quercus.parser.QuercusParser.new quercus, path, read_stream

      program = parser.parse
      functions = functions(program)
      statement = p(program.statement)
      return statement if functions.length == 0
      return functions.first if functions.length == 1
      return s(:block, *functions) if !statement
      return s(:block, functions, statement)
    end

    def to_ruby(php)
      Ruby2Ruby.new.process(convert(phps))
    end

    def node_type(node)
      node_class_name(node.java_class)
    end

    def node_class_name(klass)
      klass.name.split(".").last.snake_case.to_sym
    end

    def p(node, visitors = [], klass = nil, recursion = 0)
      return nil unless node
      visitors.each {|v| v.visit(node) }
      if @debug and node.respond_to? :location
        l = node.location
        puts "#{node_type(node)} (#{l.class_name}\##{l.function_name}) @ #{l.line_number}"
      end
      klass ||= node.java_class
      type = node_class_name(klass)
      raise "no matcher for #{node_type(node)}" if type == :object
      if respond_to? type
        return send type, node if method(type).arity == 1
        return send type, node, visitors if method(type).arity == 2
      end
      # puts "recursing to #{node_class_name(klass.superclass)} "
      p(node, visitors, klass.superclass)
    end

    def echo_statement(node)
      s(:call, nil, :print, s(:arglist, p(node.expr)))
    end

    RESERVED_WORDS = ['do', 'end', 'begin', 'rescue']

    def safe_keyword(name)
      name = name.to_s
      name = :"_#{name}" if RESERVED_WORDS.include? name
      name.to_sym
    end

    def ruby_var(name)
      s(:call, nil, safe_keyword(name), s(:arglist))
    end

    def text_statement(node)
      ruby_method :print, s(:arglist, s(:str, node.value))
    end

    def define_constant(node)
      args = node.args.to_a
      name = args.first.value.value.to_sym
      value = args.last
      s(:cdecl, name, p(value))
    end

    def assign_ref_expr(node)
      assign_expr(node)
    end

  end
end

end #Php2Rb