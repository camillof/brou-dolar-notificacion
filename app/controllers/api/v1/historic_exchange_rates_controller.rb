class Api::V1::HistoricExchangeRatesController < ApplicationController
  def index
    historic_exchange_rates = HistoricExchangeRate.all.map do |historic_exchange_rate|
      {
        id: historic_exchange_rate.id,
        value: historic_exchange_rate.value,
        updated_at: historic_exchange_rate.updated_at
      }
    end

    json_response(results: historic_exchange_rates)
  end

  def last
    response = {
      value: HistoricExchangeRate.last&.value,
      checked_at: Handler.find_by(name: ExchangeRateHandler::NAME).last_time
    }

    json_response(response)
  end
end
