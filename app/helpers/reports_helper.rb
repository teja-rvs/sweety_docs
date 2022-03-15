module ReportsHelper
  def display_table(readings)
    readings.size.positive?
  end

  def report_type
    {
      today: 'Daily Report',
      month_to_date: 'Month to date Report',
      monthly: 'Monthly Report'
    }
  end
end
