# frozen_string_literal: true

############
# BOOLEANS #
############
# We don't really need them since any object except `NullObject` instances
# are considered true. These are just for more explicitness in some contexts.
##

class Bool < NormalObject
end

class TrueObject < Bool
end

class FalseObject < Bool
  def if_branching(_then_val, else_val)
    else_val
  end
end

# Logical NOT operation. Just wraps around any object
#
#     If.new(NullObject, TrueObject.new, FalseObject.new)
#       .result # ==> false
#     If.new(BoolNot.new(NullObject), TrueObject.new, FalseObject.new)
#       .result # ==> true
#
class BoolNot < Bool
  def initialize(x)
    @x = x
  end

  def if_branching(then_val, else_val)
    @x.if_branching(else_val, then_val)
  end
end
