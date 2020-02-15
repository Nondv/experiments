require 'spec_helper'
require 'operations/add'

RSpec.describe Add do
  it 'works' do
    expect(described_class.call(4, 5)).to eq 9
  end

  it 'works with variable number of arguments' do
    expect(described_class.call(2, 3, 4, 5)).to eq 14
  end

  it 'raises ArgumentError when not enough arguments provided' do
    expect { described_class.call(4) }.to raise_error ArgumentError
  end
end
