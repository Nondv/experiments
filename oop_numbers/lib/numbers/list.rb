class List
  # @return [Object]
  attr_reader :head
  # @return [List]
  attr_reader :tail

  EMPTY = new # HACK: at this point constructor hasn't been defined yet

  def initialize(head, tail = EMPTY)
    raise TypeError unless tail.is_a?(List)

    @head = head
    @tail = tail
  end

  def add(obj)
    self.class.new(obj, self)
  end

  def empty?
    self == EMPTY
  end

  def each
    list = self
    until list.empty?
      yield list.head
      list = list.tail
    end

    self
  end

  def reduce(initial_value)
    result = initial_value
    each { |e| result = yield(result, e) }
    result
  end

  def inspect
    return '()' if empty?

    '(' + reduce('') { |a, e| "#{a}, #{e.inspect}" }[2..-1] + ')'
  end
end
