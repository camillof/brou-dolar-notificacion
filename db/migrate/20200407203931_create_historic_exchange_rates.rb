class CreateHistoricExchangeRates < ActiveRecord::Migration[6.0]
  def change
    create_table :historic_exchange_rates do |t|
      t.float :value, required: true

      t.timestamps
    end
  end
end
