# frozen_string_literal: true

class BaseObject
  def if_branching(then_val, _else_val)
    then_val
  end
end

class NormalObject < BaseObject
  def null?
    FalseObject.new
  end
end

class NullObject < BaseObject
  def if_branching(_then_val, else_val)
    else_val
  end

  def null?
    TrueObject.new
  end
end
