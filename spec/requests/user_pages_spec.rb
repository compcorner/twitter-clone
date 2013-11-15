require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "index" do
    let(:user) { FactoryGirl.create(:user) }

    before(:each) do
      sign_in user
      visit users_path
    end

    it { should have_title('All users') }
    it { should have_content('All users') }

    describe "pagination" do
      before(:all) { 30.times { FactoryGirl.create(:user) } }
      after(:all) { User.delete_all }

      it "should list each user" do
        User.paginate(page: 1).each do |user|
          expect(page).to have_selector('li', text: user.name)
        end
      end
    end

    describe "delete links" do
      it { should_not have_link('delete') }

      describe "as an admin user" do
        let(:admin) { FactoryGirl.create(:admin) }

        before do
          sign_in admin
          visit users_path
        end

        it { should have_link('delete', href: user_path(User.first)) }
        it "should be able to delete another user" do
          expect do
            click_link('delete', match: :first)
          end.to change(User, :count).by(-1)
        end
        it { should_not have_link('delete', href: user_path(admin)) }
      end
    end
  end

  describe "profile page" do
    let(:user) { FactoryGirl.create(:user) }
    let!(:m1) { FactoryGirl.create(:tweet, user: user, content: "Foo") }
    let!(:m2) { FactoryGirl.create(:tweet, user: user, content: "Bar") }

    before { visit user_path(user) }

    it { should have_content(user.name) }
    it { should have_title(user.name) }

    describe "tweets" do
      it { should have_content(m1.content) }
      it { should have_content(m2.content) }
      it { should have_content(user.tweets.count) }
    end
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

      describe "after saving the user" do
        before { click_button submit }
        let(:user) { User.find_by(email: "user@example.com") }

        it { should have_link('Sign out') }
        it { should have_title(user.name) }
        it { should have_selector('div.alert.alert-success', text: 'Welcome') }
      end
    end
  end

  describe "edit" do
    let(:user) { FactoryGirl.create(:user) }

    before do
      sign_in user
      visit edit_user_path(user)
    end

    describe "page" do
      it { should have_content("Update your profile") }
      it { should have_title("Edit profile") }
      it { should have_link("change", href: "https://gravatar.com/emails") }
    end

    describe "with invalid information" do
      before { click_button "Save changes" }

      it { should have_content('error') }
    end

    describe "with valid information" do
      let(:new_name) { "New name" }
      let(:new_email) { "new@exmaple.com" }

      before do
        fill_in "Name", with: new_name
        fill_in "E-mail", with: new_email
        fill_in "Password", with: user.password
        fill_in "Password (repeat)", with: user.password
        click_button "Save changes"
      end

      it { should have_title(new_name) }
      it { should have_selector('div.alert.alert-success') }
      it { should have_link('Sign out', href: signout_path) }
      specify { expect(user.reload.name).to eq new_name }
      specify { expect(user.reload.email).to eq new_email }
    end

    describe "cannot become an admin" do
      before do
        before { patch user_path(user) }
      end
    end
  end
end
