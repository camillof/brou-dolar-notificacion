class ExchangeRateHandler < BaseHandler
  NAME = "ExchangeRateHandler".freeze

  def initialize
    super(NAME)
  end

  def call(job, time)
    Rails.logger.debug "Checking dolar value"
    current_dolar_value = ExchangeRate.getDolarValue
    Rails.logger.debug "Current value #{current_dolar_value}"
    last_dolar_value = HistoricExchangeRate.last&.value
    if current_dolar_value != last_dolar_value
      HistoricExchangeRate.create!(value: current_dolar_value)
      if Handler.find_by(name: self.class.name).notifications_enabled?
        Rails.logger.debug "Dolar changed, sending event"
        Ifttt.triggerHook('dolar_changed', value1: last_dolar_value, value2: current_dolar_value)
      end
    end
  end

end
