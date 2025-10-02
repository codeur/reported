require "reported/version"
require "reported/engine"

module Reported
  mattr_accessor :slack_webhook_url
  mattr_accessor :enabled

  def self.configuration
    yield self if block_given?
  end
end
