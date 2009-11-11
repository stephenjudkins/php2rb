module Php2Rb
  module ControlFlow

    def if_statement(node, visitors)
      s(:if,
        p(node.test),
        p(node.true_block, visitors),
        p(node.false_block, visitors)
      )
    end

    class BreakOrContinueVisitor
      attr_reader :jumps_out_of_loop

      JUMP_STATEMENTS = [:continue_statement, :break_statement]
      def visit(node)
        type = Converter.node_type(node)
        return unless JUMP_STATEMENTS.include? type
        @jumps_out_of_loop = true if node.target
      end
    end

    def foreach_statement(node, visitors)
      visitor = BreakOrContinueVisitor.new

      block = p(node.block, visitors + [visitor])

      target = p(node.obj_expr)
      call = visitor.jumps_out_of_loop ?
        s(:call, s(:const, :Php2Rb), :foreach, s(:arglist, p(node.obj_expr))) :
        s(:call, p(node.obj_expr), :each, s(:arglist))

      block_args = if node.key
        s(:masgn, s(:array, s(:lasgn, node.key.name.to_sym), s(:lasgn, node.value.name.to_sym)))
      else
        s(:lasgn, node.value.name.to_sym)
      end

      s(:iter,
        call,
        block_args,
        block
      )
    end

    def return_statement(node)
      s(:return, p(node.expr))
    end

    alias :return_ref_statement :return_statement

    def block_statement(node, visitors)
      return s(:block, s(:nil)) if node.statements.length == 0
      s(:block, *node.statements.collect {|node| p(node, visitors)})
    end

    def switch_statement(node)
      target = p(node.value)
      body = switch_whens(node)
      default = node.default_block ? [p(node.default_block)] : []
      s(:case,
        target,
        *(body + default)
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
      if node.target
        ruby_method :continue, s(:arglist, p(node.target)), s(:const, :Php2Rb)
      else
        s(:next)
      end
    end

    def break_statement(node)
      if node.target
        ruby_method :break, s(:arglist, p(node.target)), s(:const, :Php2Rb)
      else
        s(:break)
      end
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

    def for_statement(node)
      init, block = if node_type(node.incr) == :comma_expr
        [s(:block, p(node.init), p(node.incr.right)),
         s(:block, p(node.incr.left), p(node.incr.right), p(node.block))]
      else
         [p(node.init), s(:block, p(node.block), p(node.incr))]
      end

      s(:block,
        init,
        s(:while,
          p(node.test),
          block,
          true
        )
      )
    end

    def do_statement(node)
      s(:iter,
        s(:call, nil, :loop, s(:arglist)),
        nil,
        s(:block, 
          p(node.block), 
          s(:if, p(node.test), nil, s(:break)))
      )
    end

    def throw_statement(node)
      s(:call, nil, :raise, s(:arglist, p(node.expr)))
    end

    def conditional_expr(node)
       s(:if, p(node.test), p(node.true_expr), p(node.false_expr))
    end

    def suppress_error_expr(node)
      s(:rescue, p(node.expr), s(:resbody, s(:array, s(:const, :Exception)), nil))
    end
  end
end
