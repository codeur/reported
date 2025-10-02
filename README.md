# Reported

A Rails engine that collects, stores and notifies on Slack about Content Security Policy (CSP) violation reports.

## Features

- Public `/csp-reports` endpoint for browsers to POST CSP violations
- Stores CSP reports in a database table
- Tracks notification status with `notified_at` column
- Optional Slack notifications for CSP violations
- Easy integration with Rails applications

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'reported'
```

And then execute:

```bash
$ bundle install
```

Or install it yourself as:

```bash
$ gem install reported
```

## Setup

1. Run the install generator:

```bash
$ rails generate reported:install
```

This will create an initializer at `config/initializers/reported.rb`.

2. Run the migrations:

```bash
$ rails reported:install:migrations
$ rails db:migrate
```

This creates the `reported_reports` table.

3. Mount the engine in your `config/routes.rb`:

```ruby
Rails.application.routes.draw do
  mount Reported::Engine, at: "/reported"
  # ... your other routes
end
```

This makes the CSP reports endpoint available at `/reported/csp-reports`.

## Configuration

### Content Security Policy

Configure your application's CSP to send reports to the endpoint. In `config/initializers/content_security_policy.rb`:

```ruby
Rails.application.config.content_security_policy do |policy|
  policy.default_src :self, :https
  policy.script_src  :self, :https
  # ... your other CSP directives ...
  
  # Configure the report URI
  policy.report_uri "/reported/csp-reports"
end
```

### Slack Notifications

To enable Slack notifications, configure the initializer at `config/initializers/reported.rb`:

```ruby
Reported.configuration do |config|
  # Enable or disable Slack notifications
  config.enabled = true

  # Slack webhook URL for notifications
  config.slack_webhook_url = ENV['REPORTED_SLACK_WEBHOOK_URL']
end
```

Get your Slack webhook URL from [Slack API](https://api.slack.com/messaging/webhooks).

Set the webhook URL as an environment variable:

```bash
REPORTED_SLACK_WEBHOOK_URL=https://hooks.slack.com/services/YOUR/WEBHOOK/URL
```

## Usage

Once configured, the gem automatically:

1. Receives CSP violation reports at `/reported/csp-reports`
2. Stores them in the `reported_reports` table
3. Sends notifications to Slack (if enabled)
4. Marks reports as notified with the `notified_at` timestamp

### Accessing Reports

You can access reports through the `Reported::Report` model:

```ruby
# Get all reports
Reported::Report.all

# Get unnotified reports
Reported::Report.not_notified

# Get notified reports
Reported::Report.notified

# Mark a report as notified manually
report = Reported::Report.first
report.mark_as_notified!
```

## Database Schema

The `reported_reports` table includes:

- `document_uri` - The URI of the document where the violation occurred
- `violated_directive` - The CSP directive that was violated
- `blocked_uri` - The URI that was blocked
- `original_policy` - The complete CSP policy
- `raw_report` - The complete JSON report from the browser
- `notified_at` - Timestamp of when the report was sent to Slack
- `created_at` / `updated_at` - Standard timestamps

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
