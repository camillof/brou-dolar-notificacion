class Handler < ApplicationRecord
  def self.all_with_job_info
    Handler.all.map do |handler|
      handler.with_job_attributes
    end
  end

  def start!
    if running?
      raise 'Handler already running, please stop it before running it again'
    end

    ScheduleManager.schedule_every(frequency, name.constantize.new)
  end

  def stop!
    ScheduleManager.unschedule_by_handler_name!(name)
  end

  def running?
    ScheduleManager.initialized? && ScheduleManager.find_job_by_handler_name(name).present?
  end

  def with_job_attributes
    job = ScheduleManager.find_job_by_handler_name(name)
    attributes.merge!(job_attributes: job.present? ? ScheduleManager.job_attributes(job) : {})
  end
end
