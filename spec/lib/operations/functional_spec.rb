require 'spec_helper'
require 'operations/add'
require 'operations/multiply'
require 'operations/square'

RSpec.describe 'just some tests' do
  it do
    plus_five = Add.new(5)
    expect(plus_five.call(7)).to eq 12

    twice = Multiply.new(2)
    expect(twice.call(10)).to eq 20

    # 2(5 + x^2 + y^2)
    composite = twice.comp(plus_five).comp(->(x, y) { Square.call(x) + Square.call(y) })
    expect(composite.call(3, 4)).to eq 60
  end
end
