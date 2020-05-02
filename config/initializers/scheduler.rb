Rails.application.config.after_initialize do
  do_initialize = defined?(Rails::Server) &&
                  ActiveModel::Type::Boolean.new.cast(ENV.fetch('RUN_SCHEDULER', true)) &&
                  !(defined?(Rails::Console) || Rails.env.test? || File.split($0).last == 'rake')

  if do_initialize
    ScheduleManager.initialize

    Handler.all.each do |handler|
      handler.start! if handler.enabled?
    end

  end
end
