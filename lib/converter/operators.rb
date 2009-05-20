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
      operator = node.incr > 0 ? :+ : :-
      name = node.expr.name.to_sym
      s(:lasgn, name, s(:call, s(:lvar, name), operator, s(:arglist, s(:lit, 1))))
    end

  end
end
