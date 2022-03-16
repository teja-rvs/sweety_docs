require 'rails_helper'
require_relative('../support/sign_in_helper')

feature 'Sign In' do
  include SignInHelper

  given(:user) do
    User.create!(email: 'user@clearstack.io', password: 'password')
  end

  scenario 'when logged in' do
    sign_in(user.email, user.password)
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'wrong credentials' do
    sign_in('test@clearstack.io', 'password')
    expect(page).to have_content('Invalid Email or password')
  end

  scenario 'without password' do
    sign_in(user.email, nil)
    expect(page).to have_content('Invalid Email or password')
  end

  scenario 'without email' do
    sign_in(nil, 'password')
    expect(page).to have_content('Invalid Email or password')
  end

  scenario 'redirect to daily readings' do
    sign_in(user.email, user.password)
    expect(page.current_path).to eq readings_daily_path
  end
end
