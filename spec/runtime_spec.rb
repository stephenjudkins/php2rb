require File.dirname(__FILE__) + '/spec_helper'

require 'runtime'

describe Php2Rb, "runtime" do
  describe "running loops" do
    before do
      @looper = mock("looper")
      @log = []
      @looper.should_receive(:call).any_number_of_times {|*args| @log << args}
    end

    it "should support 'continue' for nested loops" do
      Php2Rb.foreach([1,2]) do |i|
        Php2Rb.foreach([1,2,3]) do |j|
          @looper.call i,j
          Php2Rb.continue(2) if j == 2
        end
      end

      @log.should == [[1, 1], [1, 2], [2, 1], [2, 2]]
    end

    it "should support 'break' for nested loops" do
      Php2Rb.foreach([1,2]) do |i|
        Php2Rb.foreach([1,2]) do |j|
          @looper.call i, j
          Php2Rb.break(2) if j == 2
        end
      end

      @log.should == [[1, 1], [1,2]]
    end
  end

  describe "with switch statements" do
    it "should support basic recursion"
  end
end
