module Php2Rb
  module ControlFlow

    def if_statement(node)
      s(:if,
        p(node.test),
        p(node.true_block),
        p(node.false_block)
      )
    end

    def foreach_statement(node)
      s(:iter,
        s(:call, p(node.obj_expr), :each, s(:arglist)),
        s(:lasgn, node.value.name.to_sym),
        p(node.block)
      )
    end

    def return_statement(node)
      s(:return, p(node.expr))
    end

    def block_statement(node)
      return nil if node.statements.length == 0
      s(:block, *node.statements.collect {|node| p(node)})
    end


  end
end
