# require 'daemons'
# require 'byebug'

# module DaemonsManager
#   @daemons = []

#   class << self
#     def start
#       @daemons = []
#       @daemons << Daemons.call(app_name: 'exchange_rate_refresher', backtrace: true) do
#         loop do
#           # byebug
#           current_dolar_value = ExchangeRate.getDolarValue
#           Rails.logger.info "current value #{current_dolar_value}"
#           if HistoricExchangeRate.last.nil?
#             HistoricExchangeRate.create!(value: current_dolar_value)
#           else
#             last_dolar_value = HistoricExchangeRate.last.value
#             if current_dolar_value != last_dolar_value
#               Rails.logger.info "Dolar changed, sending event"
#               Ifttt.triggerHook('dolar_changed', value1: last_dolar_value, value2: current_dolar_value)
#             end
#           end
#           sleep 30*60
#         end
#       end
#     end

#     def get_daemons
#       @daemons
#     end

#     def stop_all
#       @daemons.map(&:stop)
#     end
#   end
# end
