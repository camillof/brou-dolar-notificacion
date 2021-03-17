namespace :handler do
  desc "Checks the dolar value in BROU page"

  task check_exchange_rate: :environment do
    ExchangeRateHandler.new.call
  end
end
