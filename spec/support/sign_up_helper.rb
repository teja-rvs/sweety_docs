module SignUpHelper
  def sign_up(username, password, password_confirmation)
    visit new_user_registration_path
    within('#new_user') do
      fill_in 'Email', with: username
      fill_in 'user[password]', with: password
      fill_in 'user[password_confirmation]', with: password_confirmation
    end
    click_button 'Sign up'
  end
end
