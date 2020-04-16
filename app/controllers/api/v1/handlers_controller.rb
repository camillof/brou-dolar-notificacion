class Api::V1::HandlersController < ApplicationController
  before_action :set_handler, only: [:show, :update, :stop, :start]

  def index
    json_response(Handler.all_with_job_info)
  end

  def update
    @handler.update!(update_params)
    json_response(@handler.with_job_attributes)
  end

  def stop
    @handler.stop!
    json_response(@handler.with_job_attributes)
  end

  def start
    @handler.start!
    json_response(@handler.with_job_attributes)
  end

  private

  def set_handler
    @handler = Handler.find(params[:id])
  end

  def update_params
    params.require(:handler).permit(:enabled, :notifications_enabled)
  end
end
