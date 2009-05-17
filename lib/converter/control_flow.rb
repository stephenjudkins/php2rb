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

    def switch_statement(node)
      target = p(node.value)
      default = p(node.default_block)
      s(:case,
        target,
        *(switch_whens(node) + [default])
       )
    end

    def switch_whens(node)
      node.cases.to_a.zip(node.blocks.to_a).collect do |case_expr, block|
        s(:when,
          s(:array, *case_expr.collect {|e| p(e) } ),
          block_until_return_or_break(block)
        )
      end
    end

    def continue_statement(node)
      s(:next)
    end

    def block_until_return_or_break(block)
      statements = block.statements.to_a
      statement, index = statements.zip((0...statements.length).to_a).
        detect {|statement, i| node_type(statement) == :break_statement }
      return p(block) unless index
      s(:block, *statements[0...index].collect {|n| p(n)})
    end

    def while_statement(node)
      s(:while,
        p(node.test),
        p(node.block),
        true
      )
    end
  end
end
