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
