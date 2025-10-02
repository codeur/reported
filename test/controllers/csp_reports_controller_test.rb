# frozen_string_literal: true

require 'test_helper'

module Reported
  class CspReportsControllerTest < ActionDispatch::IntegrationTest
    setup do
      @valid_csp_report_old_format = {
        'csp-report' => {
          'document-uri'       => 'https://example.com/page',
          'violated-directive' => "script-src 'self'",
          'blocked-uri'        => 'https://evil.com/script.js',
          'original-policy'    => "default-src 'self'; script-src 'self'"
        }
      }

      @valid_csp_report_new_format = {
        'documentURI'       => 'https://example.com/page',
        'violatedDirective' => "script-src 'self'",
        'blockedURI'        => 'https://evil.com/script.js',
        'originalPolicy'    => "default-src 'self'; script-src 'self'"
      }
    end

    test 'creates report with valid CSP data (old format)' do
      assert_difference 'Report.count', 1 do
        post '/csp-reports',
             params:  @valid_csp_report_old_format.to_json,
             headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      assert_response :no_content

      report = Report.last
      assert_equal 'https://example.com/page', report.document_uri
      assert_equal "script-src 'self'", report.violated_directive
      assert_equal 'https://evil.com/script.js', report.blocked_uri
    end

    test 'creates report with valid CSP data (new format)' do
      assert_difference 'Report.count', 1 do
        post '/csp-reports',
             params:  @valid_csp_report_new_format.to_json,
             headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      assert_response :no_content

      report = Report.last
      assert_equal 'https://example.com/page', report.document_uri
      assert_equal "script-src 'self'", report.violated_directive
      assert_equal 'https://evil.com/script.js', report.blocked_uri
    end

    test 'returns bad_request with invalid JSON' do
      assert_no_difference 'Report.count' do
        post '/csp-reports',
             params:  'invalid json{',
             headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      assert_response :bad_request
    end

    test 'returns bad_request with empty body' do
      assert_no_difference 'Report.count' do
        post '/csp-reports',
             params:  '',
             headers: { 'CONTENT_TYPE' => 'application/json' }
      end

      assert_response :bad_request
    end

    test 'stores raw_report as JSONB' do
      post '/csp-reports',
           params:  @valid_csp_report_old_format.to_json,
           headers: { 'CONTENT_TYPE' => 'application/json' }

      report = Report.last
      # With JSONB, raw_report is stored as a hash directly
      assert_equal @valid_csp_report_old_format.deep_stringify_keys, report.raw_report
    end

    test 'does not require CSRF token' do
      # This test verifies that external browsers can POST without CSRF token
      post '/csp-reports',
           params:  @valid_csp_report_old_format.to_json,
           headers: { 'CONTENT_TYPE' => 'application/json' }

      assert_response :no_content
    end
  end
end
