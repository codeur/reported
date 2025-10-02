module Reported
  class Report < ApplicationRecord
    validates :raw_report, presence: true

    scope :not_notified, -> { where(notified_at: nil) }
    scope :notified, -> { where.not(notified_at: nil) }

    def mark_as_notified!
      update!(notified_at: Time.current)
    end

    def notified?
      notified_at.present?
    end
  end
end
