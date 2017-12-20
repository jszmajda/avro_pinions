require "bundler/setup"
require 'pry'
require "avro_pinions"
require 'support/test_publisher'
require 'support/basic_message'

RSpec.configure do |config|
  # Enable flags like --only-failures and --next-failure
  config.example_status_persistence_file_path = ".rspec_status"

  config.expect_with :rspec do |c|
    c.syntax = :expect
  end
end

def configure_avro_pinions_for_local_test_files
  AvroPinions.configure({
    schema_registry: {
      type: :file,
      schema_path: 'spec/support/schemas'
    }
  })
end
