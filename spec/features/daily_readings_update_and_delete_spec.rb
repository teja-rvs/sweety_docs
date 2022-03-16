require 'rails_helper'
require_relative('../support/sign_in_helper')
require_relative('../support/daily_readings_hepler')
require_relative('../support/wait_for_ajax')

feature 'Daily Readings Update/Delete' do
  include SignInHelper
  include DailyReadingsHelper
  include WaitForAjax

  given(:user) do
    User.create!(email: 'user@clearstack.io', password: 'password')
  end

  given(:today_readings) do
    user.readings.today
  end

  given(:reading) do
    today_readings.first
  end

  background do
    populate_reading(user)
    sign_in(user.email, user.password)
  end

  scenario 'update reading' do
    add_reading(170, reading.id)
    click_save_readings
    expect(reading.reload.data).to eq(170)
  end

  scenario 'delete reading' do
    find_by_id(reading.id.to_s).click
    click_save_readings
    expect(today_readings.count).to eq 0
  end
  
end
