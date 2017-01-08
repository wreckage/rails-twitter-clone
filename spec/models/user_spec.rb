require 'rails_helper'

describe User do

    before :each do
        @user = FactoryGirl.create(:user)
    end

    it "has a valid factory" do
        expect(@user).to be_valid
    end

    it "is invalid without a name" do
        @user.name = ""
        expect(@user).to_not be_valid
    end

    it "is invalid without an email" do
        @user.email = ""
        expect(@user).to_not be_valid
    end

    it "is invalid with a name that is too long" do
        @user.name = 'a' * 51
        expect(@user).to_not be_valid
    end

    it "is invalid with an email that is too long" do
        @user.email = 'a' * 244 + '@example.com'
        expect(@user).to_not be_valid
    end

    it "accepts valid email addresses" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

        valid_addresses.each do |address|
            @user.email = address
            expect(@user).to be_valid
        end
    end

    it "does not accept invalid email addresses" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        invalid_addresses.each do |address|
            @user.email = address
            expect(@user).to_not be_valid
        end
    end

    it "is invalid with a non-unique email address" do
        expect(FactoryGirl.build(:user2, email: @user.email.upcase)).to be_invalid
    end

    it "saves email address in lower case" do
        mixed_email_address = "hELLo@ExAmple.COm"
        user2 = FactoryGirl.create(:user2, email: mixed_email_address)
        expect(user2.email).to eq(mixed_email_address.downcase)
    end

    it "is invalid without a password" do
        @user.password = @user.password_confirmation = " " * 6
        expect(@user).to_not be_valid
    end
    
    it "is invalid with a password shorter than 6 characters" do
        @user.password = @user.password_confirmation = "a" * 5
        expect(@user).to_not be_valid
    end

    it "returns false when authenticated? is called for a user with nil digest" do
        expect(@user.authenticated?(:remember, '')).to be false
    end

    it "follows and unfollowers another user" do
        user2 = FactoryGirl.create(:user2)
        expect(@user.following?(user2)).to be false
        @user.follow(user2)
        expect(@user.following?(user2)).to be true
        expect(user2.followers.include?(@user)).to be true
        @user.unfollow(user2)
        expect(@user.following?(user2)).to be false
    end
end
