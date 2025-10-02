class CreateReportedReports < ActiveRecord::Migration[6.0]
  def change
    create_table :reported_reports do |t|
      t.string :document_uri
      t.string :violated_directive
      t.string :blocked_uri
      t.text :original_policy
      t.text :raw_report, null: false
      t.datetime :notified_at

      t.timestamps
    end

    add_index :reported_reports, :notified_at
    add_index :reported_reports, :created_at
  end
end
