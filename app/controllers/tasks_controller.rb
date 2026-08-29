class TasksController < ApplicationController
  before_action :set_task, only: %i[toggle destroy]

  def index
    @tasks = Task.ordered
    @task = Task.new
  end

  def create
    @task = Task.new(task_params)
    if @task.save
      redirect_to tasks_path
    else
      @tasks = Task.ordered
      render :index, status: :unprocessable_entity
    end
  end

  def toggle
    @task.update(completed: !@task.completed)
    redirect_to tasks_path
  end

  def destroy
    @task.destroy
    redirect_to tasks_path
  end

  private

  def set_task
    @task = Task.find(params[:id])
  end

  def task_params
    params.require(:task).permit(:title)
  end
end
