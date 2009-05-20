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
      return array_assignment(node) if type == :array_get_expr
      return char_assignment(node) if type == :char_at_expr
      return instance_assignment(node) if type == :this_field_expr
      s(:lasgn, node.var.name.to_sym, p(node.value))
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
      # puts "1: #{p(char_at.obj_expr).inspect}"
      # puts "2: #{p(char_at_args(char_at)).inspect}"
      # puts "3: #{p(node.value).inspect}"
      s(:attrasgn, p(char_at.obj_expr), :[]=, s(:arglist, char_at_args(char_at), p(node.value)))
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

    def char_at_expr(node)
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
        index = p(node.index_expr)
        return s(:dot2, index, index)
      end
    end

  end
end
