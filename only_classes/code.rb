require_relative 'lib/basic_objects'

require_relative 'lib/if'
require_relative 'lib/while'
require_relative 'lib/booleans'
require_relative 'lib/lists'



class Counter < NormalObject
  def initialize
    @list = NullObject.new
  end

  def inc
    @list = List.new(NullObject.new, @list)
  end

  class IncCallable < NormalObject
    def initialize(counter)
      @counter = counter
    end

    def call
      @counter.inc
    end
  end

  def inc_callable
    IncCallable.new(self)
  end
end

#
# Returns a counter incremented once for each NullObject in a list
#
class CountNullsInList < NormalObject
  def initialize(list)
    @list = list
  end

  def call
    list_walk = ListWalk.new(@list)
    counter = Counter.new

    While.new(UntilListEndCondition.new(list_walk),
              LoopBody.new(list_walk, counter))
         .run

    counter
  end



  class UntilListEndCondition < NormalObject
    def initialize(list_walk)
      @list_walk = list_walk
    end

    def call
      BoolNot.new(@list_walk.finished?)
    end
  end

  class LoopBody < NormalObject
    class ReturnNull < NormalObject
      def call
        NullObject.new
      end
    end

    def initialize(list_walk, counter)
      @list_walk = list_walk
      @counter = counter
    end

    def call
      x = @list_walk.next
      If.new(x.null?, @counter.inc_callable, ReturnNull.new)
        .result
        .call
    end
  end
end

