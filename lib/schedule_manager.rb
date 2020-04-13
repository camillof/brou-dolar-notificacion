require 'rufus-scheduler'

module ScheduleManager
  @initialized = false

  class << self
    def initialize
      Rails.logger.info 'Initializing scheduler'
      scheduler = Rufus::Scheduler.singleton

      def scheduler.on_pre_trigger(job, trigger_time)
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

      @initialized = true
    end

    def schedule_every(time_period, handler_instance)
      unless handler_instance.class.method_defined?(:call)
        raise "#{handler_instance} does not implement 'call' method"
      end

      unless @initialized
        raise "ScheduleManager not initialized, please run ScheduleManager.initialize before scheduling"
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
      job = Rufus::Scheduler.singleton.jobs.find { |job| job.handler.name == handler_name }
      job.present? ? job.unschedule : (raise ArgumentError, "no job found with id #{handler_name}")
      true
    end

    def unschedule_by_job_id(job_id)
      Rufus::Scheduler.singleton.unschedule(job_id)
      true
    end

    def running_jobs
      Rufus::Scheduler.singleton.jobs.map do |job|
        {
          id: job.id,
          frequency: job.original,
          name: job.handler.name,
          started_at: Time.at(job.scheduled_at.seconds),
          next_at: Time.at(job.next_time.seconds),
          last_at: job.last_at ? Time.at(job.last_at.seconds) : nil
        }
      end
    end
  end
end
