module WithJobLogging
  extend ActiveSupport::Concern

  included do
    before_enqueue do |job|
      AsyncJobLog.create!(
        jid: job.job_id,
        state: 1,
        job_type: job.class.to_s,
        scheduled_at: job.scheduled_at ? Time.at(job.scheduled_at) : nil
      )
    end

    before_perform do |job|
      AsyncJobLog.find_by(jid: job.job_id).update!(started_at: Time.now)
    end

    after_perform do |job|
      AsyncJobLog.find_by(jid: job.job_id).update!(
        finished_at: Time.now,
        state: 2
      )
    end
  end
end
