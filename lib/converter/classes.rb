module Php2Rb
  module Classes
    def class_def_statement(node)
      klass = node.cl
      functions = klass.function_set.collect {|f| f.value }
      s(:class, klass.name.to_sym, nil, s(:scope, *functions.collect {|f| p(f)}) )
    end

    def this_expr(node)
      ruby_var :self
    end

    def this_field_expr(node)
      s(:ivar, :"@#{node.name}")
    end

    def static_statement(node)
      s(:call, nil, :php_static_var, s(:arglist, s(:hash, s(:lit, :static), s(:true))))
    end

    def global_statement(node)
      s(:call, nil, :php_global, s(:arglist, s(:lit, node.var.name.to_sym)))
    end
  end
end
