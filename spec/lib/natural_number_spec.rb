require 'natural_number'

RSpec.describe NaturalNumber do
  let(:one) { NaturalNumber::ONE }
  let(:zero) { NaturalNumber::ZERO }

  def to_ruby(n)
    n.send(:list_representation).reduce(0) { |a, _| a + 1 }
  end

  describe '+' do
    it 'works' do
      two = one + one
      expect(to_ruby(two)).to eq(2)

      three = two + one
      expect(to_ruby(three)).to eq(3)
      expect(to_ruby(one + one + one)).to eq(3)
    end

    it 'ignores zero' do
      expect(to_ruby(one + zero)).to eq(1)
      expect(to_ruby(one + one + zero)).to eq(2)
      expect(to_ruby(zero + one)).to eq(1)
    end
  end

  describe '*' do
    it 'works with positives' do
      two = one + one
      three = two + one

      expect(to_ruby(two * three)).to eq(6)
      expect(to_ruby(two * one)).to eq(2)
      expect(to_ruby(one * two)).to eq(2)
      expect(to_ruby(two * three * two)).to eq(12)
    end

    it 'works properly with zero' do
      expect(to_ruby(zero * one)).to eq(0)
      expect(to_ruby(one * zero)).to eq(0)
      expect(to_ruby(zero * (one + one + one))).to eq(0)
    end
  end

  describe '-' do
    it 'works' do
      two = one + one
      four = two + two

      expect(to_ruby(one - one)).to eq(0)
      expect(to_ruby(four - one)).to eq(3)
      expect(to_ruby(four - two)).to eq(2)
      expect(to_ruby(four - four)).to eq(0)
    end

    it 'raises error when out of bounds' do
      two = one + one
      three = one + one + one

      expect { zero - one }.to raise_error(ArgumentError)
      expect { two - three }.to raise_error(ArgumentError)
    end

    it 'ignores zero' do
      expect(to_ruby(one - zero)).to eq(1)
      expect(to_ruby(one + one - zero - zero)).to eq(2)
    end
  end

  describe 'comparison operator' do
    it '==' do
      expect(one == zero).to be false
      expect(one == one).to be true
      expect(zero == zero).to be true

      two = one + one
      expect((two + one) == (one + one + one)).to be true
      expect(one == (one + one)).to be false
    end

    it '<' do
      expect(one < zero).to be false
      expect(zero < one).to be true
      expect(one < one).to be false
      expect(zero < zero).to be false
      two = one + one
      expect(one < two).to be true
      expect(two < (two + one)).to be true
    end

    it '>' do
      expect(one > zero).to be true
      expect(zero > one).to be false
      expect(one > one).to be false
      expect(zero > zero).to be false
      two = one + one
      expect(one > two).to be false
      expect(two > (two + one)).to be false
    end

    it '<=' do
      expect(one <= zero).to be false
      expect(zero <= one).to be true
      expect(one <= one).to be true
      expect(zero <= zero).to be true
      two = one + one
      expect(one <= two).to be true
      expect(two <= two).to be true
    end

    it '>=' do
      expect(one >= zero).to be true
      expect(zero >= one).to be false
      expect(one >= one).to be true
      expect(zero >= zero).to be true
      two = one + one
      expect(one >= two).to be false
      expect(two >= (two + one)).to be false
    end
  end
end
