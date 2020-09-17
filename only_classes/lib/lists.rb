# frozen_string_literal: true

###############################
# List and everything related #
###############################


class List < NormalObject
  attr_reader :head, :tail

  def initialize(head, tail = NullObject.new)
    @head = head
    @tail = tail
  end
end

#
# Can be used to traverse a list once.
#
class ListWalk < NormalObject
  attr_reader :left

  def initialize(list)
    @left = list
  end

  # Returns current head and sets current to its tail.
  # Returns null if the end is reached
  def next
    head = If.new(left, HeadCallable.new(left), ReturnNull.new)
             .result
             .call
    @left = If.new(left, TailCallable.new(left), ReturnNull.new)
              .result
              .call
    head
  end

  def finished?
    BoolNot.new(left)
  end

  class HeadCallable < NormalObject
    def initialize(list)
      @list = list
    end

    def call
      @list.head
    end
  end

  class TailCallable < NormalObject
    def initialize(list)
      @list = list
    end

    def call
      @list.tail
    end
  end

  class ReturnNull < NormalObject
    def call
      NullObject.new
    end
  end
end

