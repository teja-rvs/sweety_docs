require 'rails_helper'
require_relative('../support/sign_in_helper')
require_relative('../support/daily_readings_hepler')
require_relative('../support/wait_for_ajax')

feature 'Daily Readings create' do
  include SignInHelper
  include DailyReadingsHelper
  include WaitForAjax
  given(:user) do
    User.create!(email: 'user@clearstack.io', password: 'password')
  end

  given(:reading) do
    user.readings << Reading.new(data: 140, recorded_at: Time.now)
    user.save!
  end
  
  background do
    sign_in(user.email, user.password)
  end

  scenario 'welcome message' do
    expect(page).to have_content("Welcome #{user.email}")
  end 
  
  scenario 'all buttons present' do
    expect(page).to have_content('Reports')
    expect(page).to have_content('Add Reading')
    expect(page).to have_content('Save Readings')
  end

  scenario 'add button limit restriction' do
    (Reading::DAILY_LIMIT + 1).times do
      find_by_id('add-reading').click
    end
    message = page.driver.browser.switch_to.alert.text
    expect(message).to eq('You can add only 4 readings per day!!!')
  end

  scenario 'only integer readings are accepted' do
    message = invalid_reading_details(rand)
    expect(message).to eq('must be an integer')
  end

  scenario 'reading cannot be blank' do
    message = invalid_reading_details(nil)
    expect(message).to eq("can't be blank")
  end

  scenario 'recorded at cannot be blank' do
    click_add_reading
    id = page.find('.delete-reading')[:id]
    add_recorded_at(nil, id)
    click_save_readings
    message = error_message('recorded_at', id)
    expect(message).to eq("can't be blank")
  end

  scenario 'reading is correctly saved' do
    click_add_reading
    id = page.find('.delete-reading')[:id]
    data = random_reading
    add_reading(data, id)
    click_save_readings
    record = user.readings.today.first
    expect(data).to eq(record.data)
  end

  scenario 'multiple readings are correctly saved' do
    Reading::DAILY_LIMIT.times do
      click_add_reading
      id = all('.delete-reading').last[:id]
      data = random_reading
      add_reading(data, id)
    end
    click_save_readings
    expect(user.readings.today.count).to eq(4)
  end

end



