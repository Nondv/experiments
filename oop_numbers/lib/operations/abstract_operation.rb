class AbstractOperation
  def self.call(*args)
    new.call(*args)
  end

  def self.to_proc
    new.to_proc
  end

  def self.curry(*args)
    new.curry(*args)
  end

  def self.comp(f)
    new.comp(f)
  end

  def initialize(*args_to_curry)
    @curried_args = args_to_curry
  end

  def call(*args)
    args = curried_args + args
    implementation(*args)
  end

  def curry(*args)
    args = curried_args + args
    self.class.new(*args)
  end

  def to_proc
    proc { |*args| call(*args) }
  end

  def comp(f)
    closure = self
    Class.new(AbstractOperation) do
      define_method(:implementation) do |*args|
        closure.call(f.call(*args))
      end
    end
  end

  def implementation(*)
    raise 'put your code here'
  end

  private

  attr_reader :curried_args
end
