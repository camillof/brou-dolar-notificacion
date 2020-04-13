class Api::V1::ScheduledJobsController < ApplicationController
  def index
    json_response(ScheduleManager.running_jobs)
  end

  def destroy
    json_response(ScheduleManager.unschedule_by_job_id(params[:id]))
  end
end
