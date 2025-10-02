# frozen_string_literal: true

module Reported
  class CspReportsController < ApplicationController
    # Skip CSRF token verification for CSP reports
    skip_before_action :verify_authenticity_token

    def create
      report_data = parse_report_data

      if report_data
        create_report(report_data)
        head :no_content
      else
        head :bad_request
      end
    rescue StandardError => e
      Rails.logger.error("Error processing CSP report: #{e.message}")
      head :internal_server_error
    end

  private

    def create_report(report_data)
      # Extract CSP report data, supporting both old and new formats
      csp_data = extract_csp_data(report_data)

      report = Report.create!(
        document_uri:       csp_data[:document_uri],
        violated_directive: csp_data[:violated_directive],
        blocked_uri:        csp_data[:blocked_uri],
        original_policy:    csp_data[:original_policy],
        raw_report:         report_data
      )

      # Send notification if enabled
      NotificationJob.perform_later(report.id) if Reported.enabled
    end

    def parse_report_data
      body = request.body.read
      return nil if body.blank?

      JSON.parse(body)
    rescue JSON::ParserError => e
      Rails.logger.error("Error parsing CSP report JSON: #{e.message}")
      nil
    end

    def extract_csp_data(report_data)
      # Support both old format (csp-report) and new format (direct fields)
      extract_properties(report_data['csp-report'] || report_data)
    end

    def extract_properties(csp_report)
      # Old format: {"csp-report": {...}}
      {
        document_uri:       csp_report['document-uri'] || csp_report['documentURI'],
        violated_directive: csp_report['violated-directive'] || csp_report['violatedDirective'] ||
          csp_report['effective-directive'] || csp_report['effectiveDirective'],
        blocked_uri:        csp_report['blocked-uri'] || csp_report['blockedURI'],
        original_policy:    csp_report['original-policy'] || csp_report['originalPolicy']
      }
    end
  end
end
