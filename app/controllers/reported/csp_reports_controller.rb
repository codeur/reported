module Reported
  class CspReportsController < ActionController::Base
    # Skip CSRF token verification for CSP reports
    skip_before_action :verify_authenticity_token

    def create
      report_data = parse_report_data

      if report_data
        report = Report.create!(
          document_uri: report_data.dig('csp-report', 'document-uri'),
          violated_directive: report_data.dig('csp-report', 'violated-directive'),
          blocked_uri: report_data.dig('csp-report', 'blocked-uri'),
          original_policy: report_data.dig('csp-report', 'original-policy'),
          raw_report: report_data.to_json
        )

        # Send notification if enabled
        NotificationJob.perform_later(report.id) if Reported.enabled

        head :no_content
      else
        head :bad_request
      end
    rescue => e
      Rails.logger.error("Error processing CSP report: #{e.message}")
      head :internal_server_error
    end

    private

    def parse_report_data
      body = request.body.read
      return nil if body.blank?

      JSON.parse(body)
    rescue JSON::ParserError => e
      Rails.logger.error("Error parsing CSP report JSON: #{e.message}")
      nil
    end
  end
end
