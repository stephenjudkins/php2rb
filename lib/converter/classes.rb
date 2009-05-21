module Php2Rb
  module Classes
    def class_def_statement(node)
      klass = node.cl
      extends = klass.parent_name
      extends = s(:const, extends.to_sym) if extends
      functions = klass.function_set.collect {|f| f.value }.sort_by {|f| f.location.line_number }.
                    collect {|f| p(f)}

      fields = klass.field_set.collect {|e| e.key.to_s.to_sym }.
                     collect {|f| s(:call, nil, :attr_accessor, s(:arglist, s(:lit, f)) ) }

      contents = s(:scope, s(:block, *(fields + functions)))
      s(:class, klass.name.to_sym, extends, contents )
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

    def new_expr(node)
      s(:call, s(:const, node.name.to_sym), :new, arguments(node.args))
    end

    def field_get_expr(node)
      ruby_method safe_keyword(node.name), s(:arglist), p(node.obj_expr)
    end

    def field_assign(node)
      obj = node.var
      method_name = :"#{obj.name.to_s}="

      ruby_method method_name, s(:arglist, p(node.value)), p(obj.obj_expr)
    end

    def class_method_expr(node)
      klass = ruby_method :class, s(:arglist), s(:self)
      ruby_method node.name, arguments(node.args), klass
    end

    def instance_of_expr(node)
      ruby_method :is_a?, s(:const, node.right.to_sym), p(node.expr)
    end
  end
end
