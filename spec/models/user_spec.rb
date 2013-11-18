require 'spec_helper'

describe User do
  before do
    @user = User.new(name: 'Example User', email: 'user@example.com',
                     password: 'foobar', password_confirmation: 'foobar')
  end

  subject { @user }

  it { should respond_to(:name) }
  it { should respond_to(:email) }
  it { should respond_to(:password_digest) }
  it { should respond_to(:password) }
  it { should respond_to(:password_confirmation) }
  it { should respond_to(:session_token) }
  it { should respond_to(:authenticate) }
  it { should respond_to(:admin) }
  it { should respond_to(:tweets) }
  it { should respond_to(:timeline) }
  it { should respond_to(:relationships) }
  it { should respond_to(:followed_users) }
  it { should respond_to(:reverse_relationships) }
  it { should respond_to(:followers) }
  it { should respond_to(:following?) }
  it { should respond_to(:follow!) }

  it { should be_valid }
  it { should_not be_admin }

  describe "with admin attribute set to 'true'" do
    before do
      @user.save!
      @user.toggle!(:admin)
    end

    it { should be_admin }
  end

  describe "when name is not present" do
    before { @user.name = "" }
    it { should_not be_valid }
  end

  describe "when email is not present" do
    before { @user.email = "" }
    it { should_not be_valid }
  end

  describe "when name is too long" do
    before { @user.name = "a" * 51 }
    it { should_not be_valid }
  end

  describe "when email format is invalid" do
    it "should be invalid" do
      addresses = %w[user@foo,com user_at_foo.org example.user@foo.
                     foo@bar_baz.com foo@bar+baz.com]
      addresses.each do |invalid_address|
        @user.email = invalid_address
        expect(@user).not_to be_valid
      end
    end
  end

  describe "when email format is valid" do
    it "should be valid" do
      addresses = %w[user@foo.COM A_US-ER@f.b.org frst.lst@foo.jp a+b@baz.cn]
      addresses.each do |valid_address|
        @user.email = valid_address
        expect(@user).to be_valid
      end
    end
  end

  describe "when email address is already taken" do
    before do
      user_with_same_email = @user.dup
      user_with_same_email.email = @user.email.upcase
      user_with_same_email.save
    end

    it { should_not be_valid }
  end

  describe "saved user email address" do
    before do
      @user_with_email = @user.dup
      @user_with_email.email = "TEST@EXAMPLE.COM"
      @user_with_email.save
    end

    it "should be lower-cased" do
      expect(@user_with_email.email).to eq("test@example.com")
    end
  end

  describe "when password is not present" do
    before do
      @user = User.new(name: "Example User", email: "user@example.com",
                       password: " ", password_confirmation: " ")
    end

    it { should_not be_valid }
  end

  describe "when password doesn't match confirmation" do
    before { @user.password_confirmation = "mismatch" }
    it { should_not be_valid }
  end

  describe "return value of authenticate method" do
    before { @user.save }
    let(:found_user) { User.find_by(email: @user.email) }

    describe "with valid password" do
      it { should eq found_user.authenticate(@user.password) }
    end

    describe "with invalid password" do
      let(:user_for_invalid_password) { found_user.authenticate("invalid") }

      it { should_not eq user_for_invalid_password }
      specify { expect(user_for_invalid_password).to be_false }
    end
  end

  describe "with a password that's too short" do
    before {
      @user.password = 'short'
      @user.password_confirmation = 'short'
    }

    it { should_not be_valid }
  end

  describe "session token" do
    before { @user.save }
    its(:session_token) { should_not be_blank }
  end

  describe "tweet associations" do
    before { @user.save }

    let!(:old_tweet) do
      FactoryGirl.create(:tweet, user: @user, created_at: 1.day.ago)
    end
    let!(:new_tweet) do
      FactoryGirl.create(:tweet, user: @user, created_at: 1.hour.ago)
    end
    let!(:older_tweet) do
      FactoryGirl.create(:tweet, user: @user, created_at: 1.year.ago)
    end

    it "should have the right tweets in the right order" do
      expect(@user.tweets.to_a).to eq [new_tweet, old_tweet, older_tweet]
    end

    it "should destroy associated tweets" do
      tweets = @user.tweets.to_a
      @user.destroy
      expect(tweets).not_to be_empty
      tweets.each do |tweet|
        expect(Tweet.where(id: tweet.id)).to be_empty
      end
    end

    describe "timeline" do
      let(:unfollowed_tweet) do
        FactoryGirl.create(:tweet, user: FactoryGirl.create(:user))
      end
      let(:followed_user) { FactoryGirl.create(:user) }

      before do
        @user.follow!(followed_user)
        3.times { followed_user.tweets.create!(content: "∇·E = ρ/ε0, ∇·B = 0, ∇xE = -∂Β/∂t, ∇xB = μ0(J + ε0 ∂E/∂t)") }
      end

      its(:timeline) { should include(new_tweet) }
      its(:timeline) { should include(old_tweet) }
      its(:timeline) { should include(older_tweet) }
      its(:timeline) { should_not include(unfollowed_tweet) }
      its(:timeline) do
        followed_user.tweets.each do |tweet|
          should include(tweet)
        end
      end
    end
  end

  describe "following" do
    let(:other_user) { FactoryGirl.create(:user) }
    before do
      @user.save
      @user.follow!(other_user)
    end

    it { should be_following(other_user) }
    its(:followed_users) { should include(other_user) }

    describe "followed user" do
      subject { other_user }
      its(:followers) { should include(@user) }
    end
  end
end
