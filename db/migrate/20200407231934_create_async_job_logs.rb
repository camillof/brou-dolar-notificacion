class CreateAsyncJobLogs < ActiveRecord::Migration[6.0]
  def change
    create_table :async_job_logs do |t|
      t.string :jid
      t.integer :state
      t.string :job_type
      t.datetime :scheduled_at
      t.datetime :started_at
      t.datetime :finished_at

      t.timestamps
    end
  end
end
