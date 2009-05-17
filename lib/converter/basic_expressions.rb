module Php2Rb
  module BasicExpressions

    def array_get_expr(node)
      s(:call, p(node.expr), :[], s(:arglist, p(node.index)) )
    end

    def append_expr(node)
      return p(node.value) unless node.next
      s(:call, p(node.value), :+, s(:arglist, p(node.next)))
    end

    def assign_expr(node)
      return array_assignment(node) if node_type(node.var) == :array_get_expr
      s(:lasgn, node.var.name.to_sym, p(node.value))
    end

    def array_assignment(node)
      assn = node.var
      s(:attrasgn, p(assn.expr), :[]=, s(:arglist, p(assn.index), p(node.value)))
    end

    def const_expr(node)
      s(:call, nil, node.var.to_sym, s(:arglist))
    end

    def var_expr(node)
      ruby_var node.name
    end

    def expr_statement(node)
      p(node.expr)
    end

    def minus_expr(node)
      if node_type(node.expr) == :var_expr
        return s(:call, p(node.expr), :-@, s(:arglist))
      end

      return s(:lit, 0-p(node.expr.value))

    end

  end
end
