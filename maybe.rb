require "bundler/inline"

gemfile do
  gem "rspec"
end

require "rspec/autorun"


# The Maybe Monad
class Maybe
  attr_reader :value

  def initialize(value)
    @value = value
  end

  private_class_method(:new)

  def self.return(arg)
    new(arg)
  end

  def bind(&block)
    if @value
      block.call(@value).tap do |new_monad|
        raise 'return value of Maybe#bind is not a Monad' unless new_monad.is_a?(Maybe)
      end
    else
      self
    end
  rescue
    p "Failed at block #{block.source_location}"
    Maybe.return(nil)
  end

  def map(&block)
    if @value
      block.call(@value).tap { |new_value| return new(new_value) }
    else
      self
    end
  rescue
    return new(nil)
  end

  def ==(other)
    raise unless other.is_a?(Maybe)

    other.value == value
  end
end


RSpec.describe "inline Bundler and autorun RSpec" do
  context 'It is an actual Monad' do
    it 'Rule 1' do
      meth = ->(value) do
        Maybe.return(value + 1)
      end

      expect(meth.call(1)).to eq(Maybe.return(1).bind(&meth))
    end

    it 'Rule 2' do
      maybe = Maybe.return(1)
      expect(maybe.bind(&Maybe.method(:return))).to eq(maybe)
    end

    it 'Rule 3' do
      meth_one = ->(value) { Maybe.return(value * 2) }
      meth_two = ->(value) { Maybe.return(value ** 2) }
      maybe = Maybe.return(rand(1000))
      expect(maybe.bind(&meth_one).bind(&meth_two)).to eq(maybe.bind { |val| meth_one.call(val).bind(&meth_two) })
    end
  end

  context 'It is a Maybe monad' do
    it 'something with an error' do
      meth = ->(value) do
        Maybe.return(value + 1)
      end
 
      expect(Maybe.return('string').bind(&meth).value).to eq(nil)
    end

    it '' do
      
    end
  end
end

# Monad.return(1).method1.method2.method3.method4.method5
