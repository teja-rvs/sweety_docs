class ReadingsController < ApplicationController
  before_action :set_user, only: %i[daily save_daily_readings]
  skip_before_action :verify_authenticity_token, only: :save_daily_readings

  def new
    @reading = Reading.new
    @reading.recorded_at = Time.now.in_time_zone('UTC')
    render partial: 'daily_form', locals: { reading: @reading }
  end

  def daily
    @readings = @user.readings.today
  end

  def save_daily_readings
    readings = params[:readings] || {}
    Reading.delete_daily_readings(readings, @user)
    errors, error_flag = Reading.create_or_update_daily_readings(readings, @user)
    if error_flag
      render json: errors, status: :unprocessable_entity
    else
      redirect_to reports_user_path(id: @user.id, report_id: 1), notice: 'Readings saved successfully'
    end
  end

  private

  def set_user
    @user = current_user
  end
end
