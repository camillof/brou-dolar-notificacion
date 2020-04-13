Rails.application.config.after_initialize do
  do_initialize = defined?(Rails::Server) || ENV['RUN_SCHEDULER'].present? && !(defined?(Rails::Console) || Rails.env.test? || File.split($0).last == 'rake')

  if do_initialize
    ScheduleManager.initialize

    ScheduleManager.schedule_every('30m', ExchangeRateHandler.new)
  end
end
