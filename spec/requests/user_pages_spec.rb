require 'spec_helper'

describe "User pages" do
  subject { page }

  describe "Signup" do
    before { visit signup_path }

    it { should have_content('Create an account') }
    it { should have_title('Create an account') }
  end
end
