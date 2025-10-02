# Configure Rails Environment
ENV["RAILS_ENV"] = "test"

require "minitest/autorun"

# Placeholder for when tests are run in a Rails application context
# This allows the gem to be tested independently
begin
  require File.expand_path("../test/dummy/config/environment", __dir__)
rescue LoadError
  # If dummy app doesn't exist, just load the engine
  require File.expand_path("../lib/reported", __dir__)
end

require "rails/test_help"

# Require webmock for testing HTTP requests
begin
  require 'webmock/minitest'
  WebMock.disable_net_connect!(allow_localhost: true)
rescue LoadError
  # webmock not available
end

# Load support files
Dir["#{File.dirname(__FILE__)}/support/**/*.rb"].each { |f| require f }

if ActiveSupport::TestCase.respond_to?(:fixture_path=)
  ActiveSupport::TestCase.fixture_path = File.expand_path("fixtures", __dir__)
  ActiveSupport::TestCase.file_fixture_path = ActiveSupport::TestCase.fixture_path + "/files"
end
