# frozen_string_literal: true

require "net/http"
require "uri"
require "json"

module Reported
  class NotificationJob < ActiveJob::Base
    queue_as :default

    def perform(report_id)
      report = Report.find_by(id: report_id)
      return unless report
      return if report.notified?
      return unless Reported.slack_webhook_url.present?

      send_slack_notification(report)
      report.mark_as_notified!
    rescue StandardError => e
      Rails.logger.error("Error sending Slack notification for report #{report_id}: #{e.message}")
      raise
    end

    private

    def send_slack_notification(report)
      uri = URI.parse(Reported.slack_webhook_url)
      http = Net::HTTP.new(uri.host, uri.port)
      http.use_ssl = true if uri.scheme == "https"

      request = Net::HTTP::Post.new(uri.path, "Content-Type" => "application/json")
      request.body = notification_payload(report).to_json

      response = http.request(request)

      return if response.code.to_i == 200

      raise "Slack API returned #{response.code}: #{response.body}"
    end

    def notification_payload(report)
      {
        text: "CSP Violation Report",
        attachments: [
          {
            color: "danger",
            fields: [
              {
                title: "Document URI",
                value: report.document_uri || "N/A",
                short: false
              },
              {
                title: "Violated Directive",
                value: report.violated_directive || "N/A",
                short: true
              },
              {
                title: "Blocked URI",
                value: report.blocked_uri || "N/A",
                short: true
              },
              {
                title: "Reported At",
                value: report.created_at.to_s,
                short: true
              }
            ]
          }
        ]
      }
    end
  end
end
