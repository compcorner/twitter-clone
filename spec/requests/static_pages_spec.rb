require 'spec_helper'

describe "StaticPages" do
  describe "Twitter" do
    it "should have the content 'Twitter'" do
      visit '/static_pages/home'
      expect(page).to have_content('Twitter')
    end
    it "should have the right title" do
      visit '/static_pages/home'
      expect(page).to have_title("Twitter")
    end
    it "should not have a custom page title" do
      visit '/static_pages/home'
      expect(page).not_to have_title("Home")
    end
  end

  describe "Help page" do
    it "should have the content 'Help'" do
      visit '/static_pages/help'
      expect(page).to have_content('Help')
    end
    it "should have the right title" do
      visit '/static_pages/help'
      expect(page).to have_title("Help - Twitter")
    end
  end

  describe "About page" do
    it "should have the content 'About'" do
      visit '/static_pages/about'
      expect(page).to have_content('About')
    end
    it "should have the right title" do
      visit '/static_pages/about'
      expect(page).to have_title("About - Twitter")
    end
  end
end
