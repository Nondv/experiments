require_relative '../util/type_checking'

class IntegerNumber
  class IsEqual
    include Util::TypeChecking

    def self.call(a, b)
      new.call(a, b)
    end

    def call(a, b)
      check_type(a, IntegerNumber)
      check_type(b, IntegerNumber)

      a.negative? == b.negative? && a.value == b.value
    end
  end
end
