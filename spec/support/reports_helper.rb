module ReportsHelper
  def visit_reports(user_id, report)
    visit reports_user_path(id: user_id, report_id: reports[report])
  end

  def check_empty(user_id, report)
    visit_reports(user_id, report)
    check_empty_content
  end

  def check_empty_content
    expect(page).to have_content('No readings found')
    expect(page).to have_no_content('Minimum value')
    expect(page).to have_no_content('Maximum value')
    expect(page).to have_no_content('Average value')
  end

  def add_month_to_date(date)
    within('form') do
      fill_in 'end_date', with: date
    end
    click_button 'Month to date Report'
  end

  def populate_daily_readings(user)
    data = []
    Reading::DAILY_LIMIT.times do
      reading = rand(140..400)
      user.readings << Reading.new(data: reading, recorded_at: Time.now)
      data << reading
    end
    user.save!
    data
  end

  def populate_monthly_readings(user, start_date, end_date)
    data = []
    (start_date..end_date).each do |day|
      4.times do
        record = Reading.new
        record.data = rand(140..170)
        record.recorded_at = "#{day} #{rand(6..18)}:00"
        user.readings << record
        data << record.data
      end
    end
    user.save!
    data
  end

  def min_value
    find('.alert', text: 'Minimum value')
  end

  def max_value
    find('.alert', text: 'Maximum value')
  end

  def avg_value
    find('.alert', text: 'Average value')
  end


  def check_report(data, scope)
    
    data_size = data.size
    data_min_value = data.min
    data_max_value = data.max
    data_avg_value = (data.sum.to_f / data_size).round(2)

    # data consistency
    expect(scope.count).to eq(data_size)
    expect(scope.minimum(:data)).to eq(data_min_value)
    expect(scope.maximum(:data)).to eq(data_max_value)
    expect((scope.sum(:data).to_f / scope.size).round(2)).to eq(data_avg_value)
  
    # UI consistency
    expect(min_value.text).to include(data_min_value.to_s)
    expect(max_value.text).to include(data_max_value.to_s)
    expect(avg_value.text).to include(data_avg_value.to_s)
  end

  def reports
    {
      daily: 1,
      month_to_date: 2,
      monthly: 3
    }
  end
end
