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
    result = block.call(value)
    if result.is_a?(Box)
      result
    else
      raise 'Is not a Box'
    end
  end
end


RSpec.describe "inline Bundler and autorun RSpec" do
  it "" do
    meth = ->(value) {Box.return(value + 1)} 
    expect(meth.call(1)).to eq(Box.return(1).bind(&meth))
  end
end
