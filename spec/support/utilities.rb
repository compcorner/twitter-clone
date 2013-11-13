include ApplicationHelper

def valid_signin(user)
  fill_in "E-mail", with: user.email
  fill_in "Password", with: user.password
  click_button "Sign in"
end

RSpec::Matchers.define :have_error_message do |message = ''|
  match do |page|
    page.has_selector?('div.alert.alert-error', text: message)
  end
end

def sign_in(user, options={})
  if options[:no_capybara]
    # Sign in when not using Capybara
    session_token = User.new_session_token
    cookies[:session_token] = session_token
    user.update_attribute(:session_token, User.encrypt(session_token))
  else
    visit signin_path
    fill_in "E-mail", with: user.email
    fill_in "Password", with: user.password
    click_button "Sign in"
  end
end
