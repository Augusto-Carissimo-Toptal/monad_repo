class Box
  attr_reader :value
  def initialize(value)
    @value = value
  end

  private_class_method(:new)
  def self.return(arg)
    new(arg)
  end
end