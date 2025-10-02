require 'test_helper'

module Reported
  class NotificationJobTest < ActiveJob::TestCase
    setup do
      @report = Report.create!(
        document_uri: "https://example.com/page",
        violated_directive: "script-src 'self'",
        blocked_uri: "https://evil.com/script.js",
        raw_report: '{"csp-report": {}}'
      )
      Reported.slack_webhook_url = "https://hooks.slack.com/services/TEST/WEBHOOK/URL"
    end

    test "sends notification to Slack" do
      stub_request(:post, Reported.slack_webhook_url)
        .to_return(status: 200, body: "ok")

      NotificationJob.perform_now(@report.id)
      
      assert_requested :post, Reported.slack_webhook_url
    end

    test "marks report as notified after successful notification" do
      stub_request(:post, Reported.slack_webhook_url)
        .to_return(status: 200, body: "ok")

      assert_nil @report.notified_at
      
      NotificationJob.perform_now(@report.id)
      
      @report.reload
      assert_not_nil @report.notified_at
    end

    test "does not send notification if report already notified" do
      @report.mark_as_notified!
      
      stub_request(:post, Reported.slack_webhook_url)
        .to_return(status: 200, body: "ok")

      NotificationJob.perform_now(@report.id)
      
      assert_not_requested :post, Reported.slack_webhook_url
    end

    test "does not send notification if webhook URL is not configured" do
      Reported.slack_webhook_url = nil
      
      stub_request(:post, "https://hooks.slack.com/services/TEST/WEBHOOK/URL")
        .to_return(status: 200, body: "ok")

      NotificationJob.perform_now(@report.id)
      
      assert_not_requested :post, "https://hooks.slack.com/services/TEST/WEBHOOK/URL"
    end

    test "includes CSP violation details in Slack message" do
      stub_request(:post, Reported.slack_webhook_url)
        .with { |request|
          body = JSON.parse(request.body)
          body["text"] == "CSP Violation Report" &&
          body["attachments"].any? { |a| 
            a["fields"].any? { |f| f["title"] == "Document URI" && f["value"] == @report.document_uri }
          }
        }
        .to_return(status: 200, body: "ok")

      NotificationJob.perform_now(@report.id)
      
      assert_requested :post, Reported.slack_webhook_url
    end
  end
end
