# frozen_string_literal: true

require_relative 'if'

class While < NormalObject
  # Calls body and then runs While#run again.
  # This way looping is done recursively (too bad no tail-call elimination)
  class NextIteration < NormalObject
    def initialize(while_obj, body)
      @while_obj = while_obj
      @body = body
    end

    def call
      @body.call
      @while_obj.run
    end
  end

  class StopLoop < NormalObject
    def call
      NullObject.new
    end
  end

  def initialize(callable_condition, callable_body)
    @cond = callable_condition
    @body = callable_body
  end

  def run
    condition_satisfied = @cond.call
    If.new(condition_satisfied,
           NextIteration.new(self, @body),
           StopLoop.new)
      .result
      .call
  end
end
