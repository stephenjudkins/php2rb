module Php2Rb
  module Operators
    {:add_expr => :+,
     :sub_expr => :-,
     :mul_expr => :*,
     :div_expr => :/,
     :gt_expr => :>,
     :lt_expr => :<,
     :eq_expr => :==
    }.each do |method_name, operator|
       define_method(method_name) { |node| binary_expr node, operator }
     end

    def binary_expr(node, operator)
      s(:call, p(node.left), operator, s(:arglist, p(node.right)))
    end

    def not_expr(node)
      s(:not, p(node.expr))
    end

  end
end
