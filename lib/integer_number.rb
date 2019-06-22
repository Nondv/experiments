require_relative 'natural_number'
require_relative 'util/type_checking'
require_relative 'integer_number/add'

class IntegerNumber
  include Util::TypeChecking

  def initialize(natural_number, is_negative = false)
    check_type(natural_number, NaturalNumber)

    @value = natural_number
    @is_negative = @value.zero? ? false : is_negative
  end

  ONE = IntegerNumber.new(NaturalNumber::ONE)
  ZERO = IntegerNumber.new(NaturalNumber::ZERO)

  def ==(other)
    check_type(other)

    negative? == other.negative? && value == other.value
  end

  def <(other)
    check_type(other)

    if negative?
      other.negative? ? (value > other.value) : true
    else
      other.negative? ? false : (value < other.value)
    end
  end

  def >(other)
    other < self
  end

  def <=(other)
    self < other || self == other
  end

  def >=(other)
    self > other || self == other
  end

  def +(other)
    check_type(other)

    return IntegerNumber.new(value + other.value, negative?) if negative? == other.negative?

    if negative?
      if value > other.value
        IntegerNumber.new(value - other.value, true)
      else
        IntegerNumber.new(other.value - value)
      end
    else
      if value > other.value
        IntegerNumber.new(value - other.value)
      else
        IntegerNumber.new(other.value - value, true)
      end
    end
  end

  def -@
    IntegerNumber.new(value, !negative?)
  end

  def -(other)
    check_type(other)

    self + (-other)
  end

  def abs
    IntegerNumber.new(value)
  end

  def negative?
    @is_negative
  end

  def positive?
    !zero? && !negative?
  end

  def zero?
    value.zero?
  end

  def inspect
    "IntegerNumber<#{'-' if negative?}#{value}>"
  end

  protected

  attr_reader :value
end
