class ReportsController < ApplicationController
  def index
    @user = User.find(params[:id])
    begin
      @report_type = get_report_type[params[:report_id]]
      @readings = set_readings(params[:end_date])
    rescue StandardError => e
      @readings = @user.readings.today
      @report_type = :today
      flash.now[:alert] = 'Report Not Found'
    end
    render :index
  end

  private

  def get_report_type
    {
      '1' => :today,
      '2' => :month_to_date,
      '3' => :monthly
    }
  end

  def set_readings(end_date)
    if @report_type == :month_to_date
      @user.readings.public_send(@report_type, end_date).order_data_wise.strict_loading
    else
      @user.readings.public_send(@report_type).order_data_wise.strict_loading
    end
  end
end
