require 'stacker/contexts'

module Stacker
  class Interpreter
    attr_reader :stack

    def initialize
      @stack = []
      @full_stack = []
      @contexts = [Contexts::Root.new(self)]
    end

    def execute(cmd)
      @contexts.last.execute(cmd)
    end

    def push_context(ctx)
      @contexts.push(ctx)
    end

    def pop_context
      @contexts.pop
    end

    def parent_context_of(child)
      child_idx = @contexts.rindex(child)
      parent_idx = child_idx - 1
      if parent_idx < 0
        raise "Unable to find parent context of #{child}"
      end
      @contexts[parent_idx]
    end

    def root_context
      @contexts.first
    end

    def push(x)
      if active?
        @stack.push(x)
      end
      @full_stack.push(x)
    end

    def pop
      if active?
        @stack.pop
      end
      @full_stack.pop
    end

    private 

    def active?
      @contexts.all?(&:active?)
    end
  end
end
