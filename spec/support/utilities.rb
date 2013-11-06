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
