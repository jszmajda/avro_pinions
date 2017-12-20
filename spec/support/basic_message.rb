class BasicMessage < AvroPinions::Message
  TOPIC = "some_topic"
  SCHEMA = "BasicSample"
  NAMESPACE = "com.company.example"

  def initialize(value)
    @value = value
  end

  def record
    { value: @value }
  end
end
