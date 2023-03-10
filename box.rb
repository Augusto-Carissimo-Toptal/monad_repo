require "bundler/inline"

gemfile do
  gem "rspec"
end

require "rspec/autorun"

class Box
  attr_reader :value

  def initialize(value)
    @value = value
  end

  private_class_method(:new)

  def self.return(arg)
    new(arg)
  end

  def bind(&block)
    block.call(value).tap do |new_box|
      raise 'return value of Box#bind is not a Box' unless new_box.is_a?(Box)
    end
  end

  def map(&blk)
    Box.return(blk.call(value))
  end

  def ==(other)
    raise unless other.is_a?(Box)

    other.value == value
  end
end


RSpec.describe "inline Bundler and autorun RSpec" do
  it 'Rule 1' do
    meth = ->(value) do
      Box.return(value + 1)
    end

    expect(meth.call(1)).to eq(Box.return(1).bind(&meth))
  end

  it 'Rule 2' do
    box = Box.return(1)
    expect(box.bind(&Box.method(:return))).to eq(box)
  end

  it 'Rule 3' do
    meth_one = ->(value) { Box.return(value * 2) }
    meth_two = ->(value) { Box.return(value ** 2) }
    box = Box.return(rand(1000))
    expect(box.bind(&meth_one).bind(&meth_two)).to eq(box.bind { |val| meth_one.call(val).bind(&meth_two) })
  end
end

