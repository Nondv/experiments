require 'spec_helper'
require 'operations/multiply'

RSpec.describe Multiply do
  it 'works' do
    expect(described_class.call(4, 5)).to eq 20
  end

  it 'works with variable number of arguments' do
    expect(described_class.call(2, 3, 4)).to eq 24
  end

  it 'uses currying when not enough arguments provided' do
    result = described_class.call(3)
    expect(result).to be_a(described_class)
    expect(result.call(4)).to eq 12
  end
end
