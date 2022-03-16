module DailyReadingsHelper
  def click_add_reading
    find_by_id('add-reading').click
    wait_for_ajax
  end

  def click_save_readings
    find_by_id('save-readings').click
    wait_for_ajax
  end

  def add_reading(data, id)
    fill_in "readings[#{id}][data]", with: data
  end

  def add_recorded_at(recorded_at, id)
    fill_in "readings[#{id}][recorded_at]", with: recorded_at
  end

  def get_error_message(attribute, id)
    find_by_id("#{attribute}_error_#{id}").text
  end

  def random_reading
    rand(140..400)
  end

  def populate_reading(user)
    user.readings << Reading.new(data: 140, recorded_at: Time.now)
    user.save!
  end
end
