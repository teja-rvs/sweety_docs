require 'rails_helper'
require_relative('../support/sign_in_helper')
require_relative('../support/reports_helper')

feature 'Reports' do
  include SignInHelper
  include ReportsHelper

  given(:user) do
    User.create!(email: 'user@clearstack.io', password: 'password')
  end

  given(:readings) do
    user.readings
  end

  given(:today) do
    readings.today
  end

  given(:monthly) do
    readings.monthly
  end

  background do
    sign_in(user.email, user.password)
  end

  scenario 'all buttons present' do
    visit_reports(user.id, :daily)
    expect(page).to have_content('Add Daily Readings')
    expect(page).to have_content('Daily Report')
    expect(page).to have_content('Monthly Report')
    expect(page).to have_button('Month to date Report')
  end

  scenario 'no data(daily)' do
    check_empty(user.id, :daily)
  end
  
  scenario 'no data(monthly)' do
    check_empty(user.id, :monthly)
  end

  scenario 'no data(month to date)' do
    visit_reports(user.id, :daily)
    add_month_to_date(Date.today)
    check_empty(user.id, :month_to_date)
  end

  scenario 'daily report' do
    data = populate_daily_readings(user)
    visit_reports(user.id, :daily)
    check_report(user, data, today)
  end

  scenario 'monthly report' do
    start_date = Date.today.months_ago(1)
    end_date = Date.today
    data = populate_monthly_readings(user, start_date, end_date)
    visit_reports(user.id, :monthly)
    check_report(user, data, monthly)
  end

  scenario 'month to date report' do
    start_date = Date.today.beginning_of_month
    end_date = rand(start_date..Date.today)
    data = populate_monthly_readings(user, start_date, end_date)
    visit_reports(user.id, :daily)
    add_month_to_date(end_date)
    scope = user.readings.month_to_date(end_date)
    check_report(user, data, scope)
  end

end
