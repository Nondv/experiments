require_relative 'abstract_operation'

class Add < AbstractOperation
  def implementation(a, b, *more)
    more.reduce(a + b, &:+)
  end
end
