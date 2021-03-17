class ExchangeRateHandler < BaseHandler
  NAME = "ExchangeRateHandler".freeze

  def initialize
    super(NAME, Handler.find_by(name: NAME))
  end

  def call(job = nil, time = nil)
    handler_config.update!(last_time: Time.now)
    Rails.logger.info "Checking dolar value"
    current_dolar_value = ExchangeRate.getDolarValue
    Rails.logger.info "Current value #{current_dolar_value}"
    last_dolar_value = HistoricExchangeRate.last&.value
    if current_dolar_value != last_dolar_value
      HistoricExchangeRate.create!(value: current_dolar_value)
      if handler_config.notifications_enabled?
        Rails.logger.info "Dolar changed, sending event"
        Ifttt.triggerHook('dolar_changed', value1: last_dolar_value, value2: current_dolar_value)
      end
    end
  end

end
