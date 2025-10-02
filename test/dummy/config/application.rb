require_relative '../../test_helper'
require 'rails/all'

Bundler.require(*Rails.groups)
require "reported"

module Dummy
  class Application < Rails::Application
    config.load_defaults Rails::VERSION::STRING.to_f
    config.eager_load = false
    
    # For compatibility with tests
    config.active_storage.service = :test if config.respond_to?(:active_storage)
  end
end
