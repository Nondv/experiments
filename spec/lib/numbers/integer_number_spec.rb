require 'numbers/integer_number'

RSpec.describe IntegerNumber do
  let(:one) { IntegerNumber::ONE }
  let(:zero) { IntegerNumber::ZERO }
  let(:minus_one) { IntegerNumber.new(NaturalNumber::ONE, true) }

  def to_ruby(n)
    abs = n.send(:value).send(:list_representation).reduce(0) { |a, _| a + 1 }
    n.negative? ? -abs : abs
  end

  describe '#+' do
    it 'works for two positives' do
      expect(to_ruby(one + one)).to eq(2)
      expect(to_ruby(one + one + one)).to eq(3)
    end

    it 'works for two negatives' do
      expect(to_ruby(minus_one + minus_one)).to eq(-2)
      expect(to_ruby(minus_one + minus_one + minus_one)).to eq(-3)
    end

    it 'works for positive and negative' do
      two = one + one
      expect(to_ruby(one + minus_one)).to eq(0)
      expect(to_ruby(minus_one + one)).to eq(0)
      expect(to_ruby(two + minus_one)).to eq(1)
      expect(to_ruby(minus_one + two)).to eq(1)
      expect(to_ruby(minus_one + one + minus_one + minus_one)).to eq(-2)
    end

    it 'ignores zero' do
      expect(to_ruby(one + zero)).to eq(1)
      expect(to_ruby(zero + one)).to eq(1)
      expect(to_ruby(zero + zero)).to eq(0)
      expect(to_ruby(minus_one + zero)).to eq(-1)
      expect(to_ruby(zero + minus_one)).to eq(-1)
    end
  end

  describe '#abs' do
    it 'works' do
      expect(one.abs).to eq(one)
      expect(minus_one.abs).to eq(one)
      expect(zero.abs).to eq(zero)
    end
  end

  describe 'comparison operator' do
    it '#==' do
      two = one + one
      expect(one == one).to be true
      expect(one == zero).to be false
      expect(zero == one).to be false
      expect(two == (one + one)).to be true
      expect(two == one).to be false

      expect(minus_one == one).to be false
      expect(one == minus_one).to be false
      expect(minus_one == minus_one).to be true
    end

    it '#<' do
      two = one + one
      expect(one < two).to be true
      expect(two < one).to be false
      expect(one < one).to be false
      expect(two < two).to be false
    end
  end
end
