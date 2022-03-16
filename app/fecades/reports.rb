module Reports
  class IndexFecade
    attr_reader :params, :user, :report_type, :readings

    def initialize(params:)
      @params = params
      @user = find_user
      @report_type = report_types[report_id]
      @readings = user_readings
    end

    def find_user
      User.find(@params[:id])
    end

    def user_readings
      user_report_readings.order_by_data.strict_loading
    end

    def user_report_readings
      if @report_type == :month_to_date
        @user.readings.public_send(@report_type, @params[:end_date])
      else
        @user.readings.public_send(@report_type)
      end
    end

    def report_id
      @params[:report_id] || '1'
    end

    def report_types
      {
        '1' => :today,
        '2' => :month_to_date,
        '3' => :monthly
      }
    end
  end
end
