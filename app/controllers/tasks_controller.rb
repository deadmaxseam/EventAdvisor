class TasksController < ApplicationController

  def update
    @task = Task.find(params[:id])
    @task.update_column(:status, update_status_param[:status])
    redirect_to request.referer
  end

  private
    def update_status_param
      params.permit(:status)
    end
end
