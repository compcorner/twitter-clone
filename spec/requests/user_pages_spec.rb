require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "Profile page" do
    let(:user) { FactoryGirl.create(:user) }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }
  end

  describe "Signup" do
    before { visit signup_path }

    it { should have_content('Create an account') }
    it { should have_title('Create an account') }
  end

  describe "Sign up" do
    before { visit signup_path }

    let(:submit) { "Create account" }

    describe "with invalid information" do
      it "should not create a user" do
        expect { click_button submit }.not_to change(User, :count)
      end
    end

    describe "with invalid email" do
      it "should display appropriate error message" do
        fill_in "Name",                with: "Example User"
        fill_in "E-mail",              with: "user_example.com"
        fill_in "Password",            with: "foobar"
        fill_in "Password (repeat)",   with: "foobar"
        click_button submit

        expect(page).to have_content('Email is invalid')
      end
    end

    describe "with valid information" do
      before do
        fill_in "Name",                with: "Example User"
        fill_in "E-mail",              with: "user@example.com"
        fill_in "Password",            with: "foobar"
        fill_in "Password (repeat)",   with: "foobar"
      end

      it "should create a user" do
        expect { click_button submit }.to change(User, :count).by(1)
      end
    end
  end
end
