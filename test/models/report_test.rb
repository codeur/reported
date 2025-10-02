# frozen_string_literal: true

require "test_helper"

module Reported
  class ReportTest < ActiveSupport::TestCase
    test "requires raw_report" do
      report = Report.new
      assert_not report.valid?
      assert_includes report.errors[:raw_report], "can't be blank"
    end

    test "can create report with raw_report" do
      report = Report.new(raw_report: { "csp-report" => {} })
      assert report.valid?
    end

    test "not_notified scope returns reports without notified_at" do
      report1 = Report.create!(raw_report: { "test" => 1 })
      report2 = Report.create!(raw_report: { "test" => 2 }, notified_at: Time.current)

      assert_includes Report.not_notified, report1
      assert_not_includes Report.not_notified, report2
    end

    test "notified scope returns reports with notified_at" do
      report1 = Report.create!(raw_report: { "test" => 1 })
      report2 = Report.create!(raw_report: { "test" => 2 }, notified_at: Time.current)

      assert_not_includes Report.notified, report1
      assert_includes Report.notified, report2
    end

    test "mark_as_notified! sets notified_at" do
      report = Report.create!(raw_report: { "test" => 1 })
      assert_nil report.notified_at

      report.mark_as_notified!
      assert_not_nil report.notified_at
    end

    test "notified? returns true when notified_at is set" do
      report = Report.create!(raw_report: { "test" => 1 })
      assert_not report.notified?

      report.update!(notified_at: Time.current)
      assert report.notified?
    end
  end
end
