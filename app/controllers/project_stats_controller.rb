class ProjectStatsController < ApplicationController
  unloadable

  before_filter :find_project

  def index
    @start_date = params[:start_date] ? Date.parse(params[:start_date]) : (Date.today - 7)
    @end_date = params[:end_date] ? Date.parse(params[:end_date]) : (Date.today)
    @include_children = params[:include_children] == "true"
  end

  private

    def find_project
      @project = Project.find(params[:project_id])
    end
end
