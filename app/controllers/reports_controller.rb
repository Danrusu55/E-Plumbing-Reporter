class ReportsController < ApplicationController
  helper_method :sort_column, :sort_direction

  def index
    @search = ReportSearch.new(params[:search])
    @reports = @search.scope.order(sort_column + " " + sort_direction)
    
    @total_calls = @reports.size
    @unique_calls = @reports.map(&:caller_id).uniq.size
    @converted_calls = @reports.select {|x| x['disposition'].include?('Paid')}.size
    @payout = @reports.map {|x| x['payout'] }.sum
    respond_to do |format|
      format.html
      format.csv { send_data @reports.to_csv, filename: "report-#{Date.today}.csv" }
    end
  end

  private

  def sort_column
    Report.column_names.include?(params[:sort]) ? params[:sort] : "date_of_call"
  end

  def sort_direction
    %w[asc desc].include?(params[:direction]) ? params[:direction] : "desc"
  end

end
