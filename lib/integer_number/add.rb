require_relative '../util/type_checking'

class IntegerNumber
  class Add
    include Util::TypeChecking

    def self.call(a, b)
      new.call(a, b)
    end

    def call(a, b)
      check_type(a, IntegerNumber)
      check_type(b, IntegerNumber)

      return IntegerNumber.new(a.value + b.value, a.negative?) if a.negative? == b.negative?

      if a.negative?
        if a.value > b.value
          IntegerNumber.new(a.value - b.value, true)
        else
          IntegerNumber.new(b.value - a.value)
        end
      else
        if a.value > b.value
          IntegerNumber.new(a.value - b.value)
        else
          IntegerNumber.new(b.value - a.value, true)
        end
      end
    end
  end
end
