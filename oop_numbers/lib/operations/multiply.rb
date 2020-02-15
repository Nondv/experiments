require_relative 'abstract_operation'

class Multiply < AbstractOperation
  def implementation(*args)
    return curry(*args) if args.size < 2

    args.reduce(1, &:*)
  end
end
