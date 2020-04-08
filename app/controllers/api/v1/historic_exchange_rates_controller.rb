class Api::V1::HistoricExchangeRatesController < ActionController::API
  def index
    historic_exchange_rates = HistoricExchangeRate.all
    historic_exchange_rates = historic_exchange_rates.map do |historic_exchange_rate|
      {
        id: historic_exchange_rate.id,
        value: historic_exchange_rate.value,
        updated_at: historic_exchange_rate.updated_at
      }
    end

    render json: { results: historic_exchange_rates }.to_json, status: :ok
  end

  def last
    response = {
      value: HistoricExchangeRate.last.value.to_json,
      checked_at: AsyncJobLog.finished.where(job_type: ExchangeRateHandler::NAME).last&.finished_at
    }
    render json: response.to_json, status: :ok
  end
end
