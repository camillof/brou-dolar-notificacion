class CreateHandlers < ActiveRecord::Migration[6.0]
  def change
    create_table :handlers do |t|
      t.string :name, required: true
      t.boolean :enabled, default: false
      t.string :frequency, default: '30m'
      t.boolean :notifications_enabled, default: false

      t.timestamps
    end
  end
end
