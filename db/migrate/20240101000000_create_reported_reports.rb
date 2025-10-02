# frozen_string_literal: true

class CreateReportedReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reported_reports do |t|
      t.string :document_uri
      t.string :violated_directive
      t.string :blocked_uri
      t.text :original_policy
      if connection.adapter_name.downcase.include?('postgresql')
        t.jsonb :raw_report, null: false, default: {}
      else
        t.json :raw_report, null: false, default: {}
      end
      t.datetime :notified_at

      t.timestamps
    end

    add_index :reported_reports, :notified_at
    add_index :reported_reports, :created_at
  end
end
