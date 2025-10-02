# frozen_string_literal: true

module Reported
  class Report < ApplicationRecord
    scope :not_notified, -> { where(notified_at: nil) }
    scope :notified, -> { where.not(notified_at: nil) }

    validates :raw_report, presence: true

    def mark_as_notified!
      update!(notified_at: Time.current)
    end

    def notified?
      notified_at.present?
    end
  end
end
