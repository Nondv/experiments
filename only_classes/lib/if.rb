# frozen_string_literal: true

class If < NormalObject
  attr_reader :result

  def initialize(bool, then_val, else_val = NullObject.new)
    @result = bool.if_branching(then_val, else_val)
  end
end

