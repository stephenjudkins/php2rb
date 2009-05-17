module Php2Rb
  module Operators
    {:add_expr => :+,
     :sub_expr => :-,
     :mul_expr => :*,
     :div_expr => :/,
     :gt_expr => :>,
     :lt_expr => :<,
     :eq_expr => :==,
     :equals_expr => :==
    }.each do |method_name, operator|
       define_method(method_name) { |node| ruby_binary_expr node, operator }
     end

    def ruby_binary_expr(node, operator)
      s(:call, p(node.left), operator, s(:arglist, p(node.right)))
    end

    def not_expr(node)
      s(:not, p(node.expr))
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
