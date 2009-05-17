module Php2Rb
  module Literals
    def long_value(node)
      node.to_long
    end

    def double_value(node)
      node.toJavaObject
    end

    def string_literal_expr(node)
      s(:str, node.value.value)
    end

    def array_fun_expr(node)
      keys = node.keys.to_a
      values = node.values.to_a
      return array(values) if keys.compact.length == 0
      hash_literal(keys, values)
    end

    def array(values)
      s(:array, *values.collect {|node| p(node)})
    end

    def hash_literal(keys, values)
      s(:hash, *keys.zip(values).flatten.collect {|node| p(node)})
    end

    def boolean_value(node)
      s(node.to_boolean ? :true : :false)
    end

    def null_literal_expr(node)
      s(:nil)
    end

    def literal_expr(node)
      value = node.value
      return p(value) if node_type(value) == :boolean_value
      s(:lit, p(value))
    end


  end
end
