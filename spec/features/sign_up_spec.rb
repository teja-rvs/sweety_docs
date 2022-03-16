require 'rails_helper'
require_relative('../support/sign_up_helper')

feature 'Sign Up' do
  include SignUpHelper

  scenario 'when sign up' do
    sign_up('newuser@clearstack.io', 'password', 'password')
    expect(page).to have_content('You have signed up successfully')
  end

  scenario 'invalid email (without @)' do
    sign_up('newuser', 'password', 'password')
    message = page.find('#user_email').native.attribute('validationMessage')
    expect(message).to eq "Please include an '@' in the email address. 'newuser' is missing an '@'."
  end

  scenario 'invalid email (without anything after @)' do
    sign_up('newuser@', 'password', 'password')
    message = page.find('#user_email').native.attribute('validationMessage')
    expect(message).to eq "Please enter a part following '@'. 'newuser@' is incomplete."
  end

  scenario 'existing email' do
    User.create!(email: 'user@clearstack.io', password: 'password')
    sign_up('user@clearstack.io', nil, nil)
    expect(page).to have_content('has already been taken')
  end

  scenario 'without password confirmation' do
    sign_up('user@clearstack.io', 'password', nil)
    expect(page).to have_content("doesn't match Password")
  end
end
