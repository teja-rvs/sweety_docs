require 'rails_helper'
require_relative('../support/sign_in_helper')

feature 'Sign In User' do
  include SignInHelper

  given(:user) do
    User.create!(email: 'user@clearstack.io', password: 'password')
  end

  scenario 'sign in with correct credentials' do
    sign_in(user.email, user.password)
    expect(page).to have_content('Signed in successfully')
  end

  scenario 'sign in with wrong credentials' do
    sign_in('test@clearstack.io', 'password')
    expect(page).to have_content('Invalid Email or password')
  end

  scenario 'sign in without password' do
    sign_in(user.email, nil)
    expect(page).to have_content('Invalid Email or password')
  end

  scenario 'sign in without email' do
    sign_in(nil, 'password')
    expect(page).to have_content('Invalid Email or password')
  end
end
