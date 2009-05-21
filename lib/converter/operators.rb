module Php2Rb
  module Operators
    {:add_expr => :+,
     :sub_expr => :-,
     :mul_expr => :*,
     :div_expr => :/,
     :gt_expr => :>,
     :geq_expr => :>=,
     :lt_expr => :<,
     :leq_expr => :<=,
     :eq_expr => :==,
     :equals_expr => :==,
     :bit_and_expr => :&,
     :bit_or_expr => :|,
     :bit_xor_expr => :"^",
     :xor_expr => :"^",
     :mod_expr => :"%"
    }.each do |method_name, operator|
       define_method(method_name) { |node| ruby_binary_expr node, operator }
     end

    def neq_expr(node)
      s(:not, ruby_binary_expr(node, :==))
    end

    def ruby_binary_expr(node, operator)
      s(:call, p(node.left), operator, s(:arglist, p(node.right)))
    end

    def not_expr(node)
      s(:not, p(node.expr))
    end

    def bit_not_expr(node)
      s(:call, p(node.expr), :~, s(:arglist))
    end

    def and_expr(node)
      s(:and, p(node.left), p(node.right))
    end

    def or_expr(node)
      s(:or, p(node.left), p(node.right))
    end

    def post_increment_expr(node)
      type = node_type(node.expr)
      return array_post_increment(node) if type == :array_get_expr
      name = type == :this_field_expr ? :"@#{node.expr.name.to_s.to_sym}" : node.expr.name.to_sym
      s(:lasgn, name, s(:call, s(:lvar, name), incr_operator(node), s(:arglist, s(:lit, 1))))
    end

    def array_post_increment(node)
      arr = node.expr
      s(:op_asgn1, p(arr.expr), s(:arglist, p(arr.index)), incr_operator(node), s(:lit, 1))
    end

    def incr_operator(node)
      node.incr > 0 ? :+ : :-
    end

    alias :pre_increment_expr :post_increment_expr

  end
end
