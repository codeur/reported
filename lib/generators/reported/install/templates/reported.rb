# frozen_string_literal: true

Reported.configuration do |config|
  # Enable or disable Slack notifications
  config.enabled = true

  # Slack webhook URL for notifications
  # Get your webhook URL from https://api.slack.com/messaging/webhooks
  config.slack_webhook_url = ENV.fetch('REPORTED_SLACK_WEBHOOK_URL', nil)
end
