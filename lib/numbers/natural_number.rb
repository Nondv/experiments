require_relative 'list'
require_relative 'util/type_checking'

class NaturalNumber
  include Util::TypeChecking

  def initialize(list_representation)
    check_type(list_representation, List)

    @list_representation = list_representation
  end

  ZERO = new(List::EMPTY)
  ONE = new(List.new(nil, List::EMPTY))

  def +(other)
    check_type(other)

    NaturalNumber.new(
      other.list_representation.reduce(list_representation) do |list, _|
        list.add(nil)
      end
    )
  end

  def *(other)
    check_type(other)

    other.list_representation.reduce(ZERO) { |a, _| a + self }
  end

  def -(other)
    check_type(other)
    raise ArgumentError if other > self

    NaturalNumber.new(
      other.list_representation.reduce(list_representation) { |a, _| a.tail }
    )
  end

  def ==(other)
    check_type(other)

    a = list_representation
    b = other.list_representation

    until a.empty? || b.empty?
      a = a.tail
      b = b.tail
    end

    a.empty? && b.empty?
  end

  def <(other)
    check_type(other)

    list = other.list_representation
    list_representation.each do
      return false if list.empty?

      list = list.tail
    end

    !list.empty?
  end

  def <=(other)
    self < other || self == other
  end

  def >(other)
    other < self
  end

  def >=(other)
    other <= self
  end

  def zero?
    self == ZERO
  end

  def inspect
    "NaturalNumber<#{list_representation.reduce(0) { |a, _| a + 1 }}>"
  end

  protected

  attr_reader :list_representation

  private

  def check_type(obj, type = NaturalNumber)
    raise TypeError unless obj.is_a?(type)
  end
end
