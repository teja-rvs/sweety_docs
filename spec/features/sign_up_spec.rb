require 'rails_helper'
require_relative('../support/sign_up_helper')

feature 'Sign Up User' do
  include SignUpHelper

  scenario 'sign up with valid details' do
    sign_up('newuser@clearstack.io', 'password', 'password')
    expect(page).to have_content('You have signed up successfully')
  end

  scenario 'sign up with invalid email (without @)' do
    sign_up('newuser', 'password', 'password')
    message = page.find('#user_email').native.attribute('validationMessage')
    expect(message).to eq "Please include an '@' in the email address. 'newuser' is missing an '@'."
  end

  scenario 'sign up with invalid email (without anything after @)' do
    sign_up('newuser@', 'password', 'password')
    message = page.find('#user_email').native.attribute('validationMessage')
    expect(message).to eq "Please enter a part following '@'. 'newuser@' is incomplete."
  end

  scenario 'sign up with existing email' do
    User.create!(email: 'user@clearstack.io', password: 'password')
    sign_up('user@clearstack.io', nil, nil)
    expect(page).to have_content('has already been taken')
  end

  scenario 'sign up with without password confirmation' do
    sign_up('user@clearstack.io', 'password', nil)
    expect(page).to have_content("doesn't match Password")
  end
end
