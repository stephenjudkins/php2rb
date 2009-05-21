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
      type = node_type(node.var)
      return array_assignment(node) if [:array_get_expr, :array_get_get_expr].include?(type)
      return char_assignment(node) if type == :char_at_expr
      return instance_assignment(node) if type == :this_field_expr
      return append_array(node) if type == :array_tail_expr
      return field_assign(node) if type == :field_get_expr
      s(:lasgn, safe_keyword(node.var.name), p(node.value))
    end

    def append_array(node)
      ruby_method :<<, s(:arglist, p(node.value)), p(node.var.expr)
      # s(:call, s(:call, nil, :stack, s(:arglist)), :<<, s(:arglist, s(:call, nil, :val, s(:arglist))))
    end

    def instance_assignment(node)
      s(:iasgn, :"@#{node.var.name}", p(node.value))
    end

    def array_assignment(node)
      assn = node.var
      s(:attrasgn, p(assn.expr), :[]=, s(:arglist, p(assn.index), p(node.value)))
    end

    def char_assignment(node)
      char_at = node.var
      s(:attrasgn, p(char_at.obj_expr), :[]=, s(:arglist, char_at_args(char_at), p(node.value)))
    end

    def const_expr(node)
      s(:call, nil, node.var.to_sym, s(:arglist))
    end

    def var_expr(node)
      name = node.name
      ruby_var name
    end

    def ref_expr(node)
      p(node.expr)
    end
    # alias :ref_expr :var_expr

    def expr_statement(node)
      p(node.expr)
    end

    def minus_expr(node)
      type = node_type(node.expr)

      return s(:lit, 0-p(node.expr.value)) if type == :literal_expr
      s(:call, p(node.expr), :-@, s(:arglist))
    end

    def char_at_expr(node)
      # return ruby_method :omg
      args = char_at_args(node)
      s(:call,
        p(node.obj_expr),
        :[],
        s(:arglist, args)
      )
    end

    def char_at_args(node)
      if node_type(node.index_expr) == :literal_expr
        i = node.index_expr.value.toJavaObject
        return s(:lit, i..i)
      else
        return s(:dot2, p(node.index_expr), p(node.index_expr))
      end
    end

    def to_long_expr(node)
      ruby_method :to_i, s(:arglist), p(node.expr)
    end

    def unset_var_expr(node)
      raise "how?" unless node_type(node.var) == :array_get_expr

      ruby_method :delete, p(node.var.index), p(node.var.expr)
    end

    def list_expr(node)
      # s(:masgn, s(:array, s(:lasgn, :element), s(:lasgn, :content), s(:lasgn, :params), s(:lasgn, :tags)), s(:splat, s(:call, nil, :data, s(:arglist))))
      refs = node.list_head.var_list.collect {|k| s(:lasgn, k.name.to_sym) }
      s(:masgn, s(:array, *refs), s(:splat, p(node.value)))
      # list_expr
    end
  end
end
