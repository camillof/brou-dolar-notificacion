require 'rufus-scheduler'

module ScheduleManager
  class << self
    def initialize
      Rails.logger.info 'Initializing scheduler'
      scheduler = Rufus::Scheduler.singleton

      def scheduler.on_pre_trigger(job, trigger_time)
        # byebug
        Rails.logger.info "Excecuting #{job.handler.name}"
        AsyncJobLog.where(jid: job.id).last.update!(
          started_at: Time.now,
          state: 1
        )
      end

      def scheduler.on_post_trigger(job, trigger_time)
        Rails.logger.info "#{job.handler.name} Finished"
        AsyncJobLog.where(jid: job.id).last.update!(
          finished_at: Time.now,
          state: 2
        )

        AsyncJobLog.create!(
          jid: job.id,
          scheduled_at: Time.at(job.next_time.seconds),
          job_type: job.handler.name,
          state: 0
        )
      end

      def scheduler.on_error(job, error)
        Rails.logger.error(
          "err#{error.object_id} rufus-scheduler intercepted #{error.inspect}" +
          " in job #{job.inspect}")
        error.backtrace.each_with_index do |line, i|
          Rails.logger.error(
            "err#{error.object_id} #{i}: #{line}")
        end
      end

      at_exit do
        Rails.logger.info "Shutting down scheduler..."
        scheduler.shutdown
        Rails.logger.info "Scheduler off"
      end
    end

    def schedule_every(time_period, handler_instance)
      unless handler_instance.class.method_defined?(:call)
        raise "#{handler_instance} does not implement 'call' method"
      end

      job = Rufus::Scheduler.singleton.schedule_every time_period, handler_instance

      AsyncJobLog.create!(
        jid: job.id,
        job_type: job.handler.name,
        scheduled_at: Time.at(job.next_time.seconds),
        state: 0
      )

      Rails.logger.info "#{handler_instance.name} scheduled to run every #{time_period}"
    end

    def unschedule_by_handler_name!(handler_name)
      Rufus::Scheduler.singleton.find {|job| job.handler.name == handler_name}.unschedule
    end
  end
end
