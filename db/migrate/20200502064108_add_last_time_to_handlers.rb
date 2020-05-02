class AddLastTimeToHandlers < ActiveRecord::Migration[6.0]
  def change
    add_column :handlers, :last_time, :datetime
  end
end
