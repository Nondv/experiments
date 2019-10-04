require 'spec_helper'
require 'operations/abstract_operation'

RSpec.describe AbstractOperation do
  describe 'currying' do
    it 'works through instantiation' do
      instance = described_class.new(:a, :b)
      expect(instance).to receive(:implementation).with(:a, :b, :c)
      instance.call(:c)
    end

    it 'can be applied to instances as well' do
      first_arg = described_class.new(1)
      second_arg = first_arg.curry(2)
      third_arg = second_arg.curry(3)

      expect(first_arg).to receive(:implementation).with(1)
      first_arg.call

      expect(second_arg).to receive(:implementation).with(1, 2)
      second_arg.call

      expect(third_arg).to receive(:implementation).with(1, 2, 3, :additional)
      third_arg.call(:additional)
    end

    it 'works on class-level' do
      expect_any_instance_of(described_class).to(
        receive(:implementation).with(:a, :b, :c)
      )
      described_class.curry(:a, :b).call(:c)
    end
  end

  describe 'implicit conversion to proc' do
    it 'works on class itself' do
      expect_any_instance_of(described_class).to(
        receive(:implementation).with(123)
      )

      [123].map(&described_class)
    end

    it 'is a multi-parameter proc' do
      expect_any_instance_of(described_class).to(
        receive(:implementation).with(1, 2, 3)
      )

      described_class.to_proc.call(1, 2, 3)
    end

    it 'works on instances' do
      instance = described_class.new
      expect(instance).to receive(:implementation).with(1, 2, 3)
      instance.to_proc.call(1, 2, 3)
    end

    it 'works with currying' do
      instance = described_class.new(1, 2)
      expect(instance).to receive(:implementation).with(1, 2, 3)
      instance.to_proc.call(3)
    end
  end
end
