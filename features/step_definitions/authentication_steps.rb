Given /^a user visits the sign in page$/ do
  visit signin_path
end

When /^s?he submits invalid sign in information$/ do
  click_button "Sign in"
end

Then /^s?he should see an error message$/ do
  expect(page).to have_selector('div.alert.alert-error')
end

Given /^the user has an account$/ do
  @user = User.create(name: "Example User", email: "user@example.com",
                      password: "foobar", password_confirmation: "foobar")
end

When /^the user submits valid sign in information$/ do
  fill_in "E-mail", with: @user.email
  fill_in "Password", with: @user.password
  click_button "Sign in"
end

Then /^s?he should see (?:his|her) profile page$/ do
  expect(page).to have_title(@user.name)
end

Then /^s?he should see a sign out link$/ do
  expect(page).to have_link('Sign out', href: signout_path)
end
