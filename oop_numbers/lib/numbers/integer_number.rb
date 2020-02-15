require_relative 'natural_number'
require_relative 'util/type_checking'
require_relative 'integer_number/add'
require_relative 'integer_number/less_than'
require_relative 'integer_number/is_equal'

class IntegerNumber
  include Util::TypeChecking

  attr_reader :value

  def initialize(natural_number, is_negative = false)
    check_type(natural_number, NaturalNumber)

    @value = natural_number
    @is_negative = @value.zero? ? false : is_negative
  end

  ONE = IntegerNumber.new(NaturalNumber::ONE)
  ZERO = IntegerNumber.new(NaturalNumber::ZERO)

  def ==(other)
    check_type(other)

    IsEqual.call(self, other)
  end

  def <(other)
    check_type(other)

    LessThan.call(self, other)
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

    Add.call(self, other)
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
end
