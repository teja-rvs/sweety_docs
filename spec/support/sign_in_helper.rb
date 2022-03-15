module SignInHelper
  def sign_in(username, password)
    visit root_path
    within('#new_user') do
      fill_in 'Email', with: username
      fill_in 'user[password]', with: password
    end
    click_button 'Log in'
  end
end
