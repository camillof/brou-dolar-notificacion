return if (!defined?(Rails::Server) || defined?(Rails::Console) || Rails.env.test? || File.split($0).last == 'rake') && !ENV['RUN_SCHEDULER'].present?

Rails.application.config.after_initialize do
  ScheduleManager.initialize

  ScheduleManager.schedule_every('30m', ExchangeRateHandler.new)
end
