class ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @search = ReportSearch.new(params[:search])
    @reports = @search.scope
    #@reports = Report.order(sort_column + " " + sort_direction).paginate(:per_page => 50, :page => params[:page])
  end

  private

  def sort_column
    Report.column_names.include?(params[:sort]) ? params[:sort] : "date_of_call"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "asc"
  end

end
