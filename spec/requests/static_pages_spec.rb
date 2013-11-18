require 'spec_helper'

describe "StaticPages" do
  subject { page }

  describe "Home page" do
    before { visit root_path }

    it { should have_content('Twitter') }
    it { should have_title("Twitter") }
    it { should_not have_title("Home") }
    it { should_not have_title('Twitter - Twitter') }

    describe "for signed-in users" do
      let(:user) { FactoryGirl.create(:user) }
      before do
        FactoryGirl.create(:tweet, user: user, content: "Hello, world")
        FactoryGirl.create(:tweet, user: user, content: "Goodbye, world")
        sign_in user
        visit root_path
      end

      it "should render the user's timeline" do
        user.timeline.each do |item|
          expect(page).to have_selector("li#tweet_#{item.id}", text: item.content)
        end
      end

      describe "follower/following counts" do
        let(:other_user) { FactoryGirl.create(:user) }
        before do
          other_user.follow!(user)
          visit root_path
        end

        it { should have_link("0 Following", href: following_user_path(user)) }
        it { should have_link("1 Followers", href: followers_user_path(user)) }
      end
    end
  end

  describe "Help page" do
    before { visit help_path }

    it { should have_content('Help') }
    it { should have_title("Help - Twitter") }
  end

  describe "About page" do
    before { visit about_path }

    it { should have_content('About') }
    it { should have_title("About - Twitter") }
  end

  describe 'Contact page' do
    before { visit contact_path }

    it { should have_content('Contact') }
    it { should have_title('Contact') }
  end
end
