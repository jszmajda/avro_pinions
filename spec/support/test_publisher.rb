class TestPublisher
  attr_reader :messages

  def initialize
    reset!
  end

  def reset!
    @messages = Hash.new([])
  end

  def publish(topic, message)
    @messages[topic] << message
  end
end
