class CreateReportedReports < ActiveRecord::Migration[7.1]
  def change
    create_table :reported_reports do |t|
      t.string :document_uri
      t.string :violated_directive
      t.string :blocked_uri
      t.text :original_policy
      t.jsonb :raw_report, null: false, default: {}
      t.datetime :notified_at

      t.timestamps
    end

    add_index :reported_reports, :notified_at
    add_index :reported_reports, :created_at
  end
end
