module SignUpHelper
  def sign_up(username, password, password_confirmation)
    visit new_user_registration_path
    fill_sign_up_form(username, password, password_confirmation)
    click_button 'Sign up'
  end

  def fill_sign_up_form(username, password, password_confirmation)
    within('#new_user') do
      fill_in 'Email', with: username
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password_confirmation
    end
  end
  
  def email_tooltip_message
    page.find('#user_email').native.attribute('validationMessage')
  end

end
