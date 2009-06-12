module Php2Rb
  module Methods

    FUNCTION_OVERRIDES = {
      :define => :define_constant,
      :isset => :ruby_defined
    }

    def ruby_defined(node)
      ruby_method :defined?, arguments(node.args)
    end

    def functions(program)
      program.functions.collect {|f| p(f) }
    end

    def function(node)
      s(:defn,
        safe_keyword(node.name),
        s(:args, *node.args.inject([]) {|m, arg| m += p(arg); m } ),
        s(:scope, p(node.statement))
      )
    end

    def function_expr(node)
      name = node.name.to_sym
      override = FUNCTION_OVERRIDES[name]
      return send(override, node) if override
      ruby_method name, arguments(node.args)
    end

    def static_method_expr(node)
      s(:call,
        s(:const, node.class_name.to_sym),
        node.method_name.to_sym,
        arguments(node.args)
      )
    end

    def method_call_expr(node)
      ruby_method node.name, arguments(node.args), p(node.obj_expr)
    end

    def ruby_method(method_name, args=s(:arglist), target=nil)
      s(:call, target, safe_keyword(method_name), args)
    end

    def arguments(args)
      s(:arglist, *args.collect {|a| p(a)})
    end

    def arg(node)
      name = node.name.to_sym
      return [name] if node_type(node.default) == :required_expr
      return [name, s(:block, s(:lasgn, name, p(node.default)))]
    end


  end
end
