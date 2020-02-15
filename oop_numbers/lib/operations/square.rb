require_relative 'abstract_operation'

class Square < AbstractOperation
  def implementation(x)
    x * x
  end
end
