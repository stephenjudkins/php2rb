module Php2Rb

  class LoopJumpException < Exception
    attr_reader :depth
    def initialize(depth=1)
      @depth = depth
    end
  end

  class ContinueLoop < LoopJumpException; end
  class BreakLoop < LoopJumpException; end

  module_function
  def continue(depth=1)
    raise ContinueLoop.new(depth)
  end

  def break(depth=1)
    raise BreakLoop.new(depth)
  end

  def foreach(iterable)
    iterable.each do |i|
      begin
        yield i
      rescue ContinueLoop => e
        next if e.depth == 1
        raise ContinueLoop.new(e.depth - 1)
      rescue BreakLoop => e
        break if e.depth == 1
        raise BreakLoop.new(e.depth - 1)
      end
    end
  end
end
