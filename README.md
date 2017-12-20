# AvroPinions

Opinionated stuff around AVRO in Ruby. Goals:

* Support some generic schema registry. You plug it in, conform to my API spec.
* Support [Single-Object Encoding](http://avro.apache.org/docs/1.8.2/spec.html#single_object_encoding) out of the box
    * Writing for now. Maybe reading later.


## Installation

Add this line to your application's Gemfile:

```ruby
gem 'avro_pinions'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install avro_pinions

## Usage

```ruby
# define a publisher. It has to have one method: `#publish`
class MyPublisher
  # publish needs receive a topic and a message
  # message is binary encoded AVRO data
  def publish(topic, message)
    # depending on how your transport mechanism works you may need to convert
    # binary data to ascii characters or something. I recommend Base64 if you
    # have to do that
    extra_encoded = make_binary_data_wire_safe(message)
    SomeTransferMechanismIOwn.send(topic, extra_encoded)
  end
end

# configure AvroPinions
AvroPinions.configure({
  wire_format: :single_object,
  schema_registry: {
    type: :file,
    schema_path: 'doc/schemas'
  },
  publisher: MyPublisher.new
})

# define a message. They inherit from AvroPinions::Message
class SomeMessage < AvroPinions::Message
  # define these constants or override `topic`, `schema`, and `namespace`
  # methods
  TOPIC = "some_topic"
  SCHEMA = "SchemaName"
  NAMESPACE = "com.company.namespace"

  def initialize(data)
    @data = data
  end

  # this method must return a json object that will be encoded with the AVRO
  # schema
  def record
    { key: @data.value }
  end
end

message = SomeMessage.new({ data... })
if message.valid?
  AvroPinions.publish(message)
end
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and tags, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/jszmajda/avro_pinions. This project is intended to be a safe, welcoming space for collaboration, and contributors are expected to adhere to the [Contributor Covenant](http://contributor-covenant.org) code of conduct.


## License

The gem is available as open source under the terms of the [MIT License](http://opensource.org/licenses/MIT).

