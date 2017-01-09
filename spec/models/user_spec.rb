require 'rails_helper'

describe User do

    before { @user = FactoryGirl.create(:user) }

    subject { @user }

    it { is_expected.to respond_to(:name) }
    it { is_expected.to respond_to(:email) }
    it { is_expected.to respond_to(:password_digest) }
    it { is_expected.to respond_to(:password) }
    it { is_expected.to respond_to(:password_confirmation) }
    it { is_expected.to respond_to(:authenticate) }
    it { is_expected.to respond_to(:feed) }
    it { is_expected.to respond_to(:active_relationships) }
    it { is_expected.to respond_to(:passive_relationships) }
    it { is_expected.to respond_to(:followers) }
    it { is_expected.to respond_to(:following) }
    it { is_expected.to respond_to(:follow) }
    it { is_expected.to respond_to(:unfollow) }
    it { is_expected.to respond_to(:following?) }
    it { is_expected.to be_valid }

    describe "when name is not present" do
        before { @user.name = " " }
        it { is_expected.not_to be_valid }
    end

    describe "when email is not present" do
        before { @user.email = " " }
        it { is_expected.not_to be_valid }
    end

    describe "when name is too long" do
        before { @user.name = 'a' * 51 }
        it { is_expected.not_to be_valid }
    end

    describe "when email is too long" do
        before { @user.email = 'a' * 244 + '@example.com' }
        it { is_expected.not_to be_valid }
    end

    describe "when email format is valid" do
        it "will be valid" do
            valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                             first.last@foo.jp alice+bob@baz.cn]

            valid_addresses.each do |address|
                @user.email = address
                expect(@user).to be_valid
            end
        end
    end

    describe "when email format is invalid" do
        it "will be invalid" do
            invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                               foo@bar_baz.com foo@bar+baz.com foo@bar..com]
            invalid_addresses.each do |address|
                @user.email = address
                expect(@user).to be_invalid
            end
        end
    end

    describe "when email address is already taken" do
        it "will be invalid" do
            expect(FactoryGirl.build(:user, email: @user.email.upcase)).to be_invalid
        end
    end

    describe "when password is not present" do
        before { @user.password = @user.password_confirmation = " " }
        it { is_expected.not_to be_valid }
    end

    describe "when password is shorter than 6 characters" do
        before { @user.password = @user.password_confirmation = "a" * 5 }
        it { is_expected.not_to be_valid }
    end
 #################################################
    it "saves email address in lower case" do
        mixed_email_address = "hELLo@ExAmple.COm"
        user = FactoryGirl.create(:user, email: mixed_email_address)
        expect(user.email).to eq(mixed_email_address.downcase)
    end


    it "returns false when authenticated? is called for a user with nil digest" do
        expect(@user.authenticated?(:remember, '')).to be false
    end

    it "destroys associated microposts when it itself is destroyed" do
        user = FactoryGirl.create(:user, microposts_count: 1)
        expect { user.destroy }.to change { Micropost.count }.by(-1)
    end

    it "follows and unfollowers another user" do
        user = FactoryGirl.create(:user)
        expect(@user.following?(user)).to be false
        @user.follow(user)
        expect(@user.following?(user)).to be true
        expect(user.followers.include?(@user)).to be true
        @user.unfollow(user)
        expect(@user.following?(user)).to be false
    end

    describe "feed" do
        let(:john) { @user }
        let(:abigail) { FactoryGirl.create(:user) }
        let(:lana) { FactoryGirl.create(:user) }

        it "shows the posts of following users" do
            john.follow(lana)
            lana.microposts.each do |post_following|
                expect(john.feed).to include(post_following)
            end
        end

        it "shows own posts" do
            john.microposts.each do |post_self|
                expect(john.feed).to include(post_self)
            end
        end

        it "does not show posts of unfollowers" do
            abigail.microposts.each do |post_unfollowing|
                expect(john.feed).not_to include(post_unfollowing)
            end
        end
    end
end
