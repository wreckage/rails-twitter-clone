require 'test_helper'

class UserTest < ActiveSupport::TestCase

    def setup
        @user = User.new(
            name: "Example User", email: "user@example.com",
            password: "foobar", password_confirmation: "foobar"
        )
    end

    test "should be valid" do
        assert @user.valid?
    end

    test "name should be present" do
        @user.name = "   "
        assert_not @user.valid?
    end

    test "email should be present" do
        @user.email = "  "
        assert_not @user.valid?
    end

    test "name should not be too long" do
        @user.name = 'a' * 51
        assert_not @user.valid?
    end

    test "email should not be too long" do
        @user.email = 'a' * 244 + '@example.com'
        assert_not @user.valid?
    end

    test "valid email addresses should be accepted" do
        valid_addresses = %w[user@example.com USER@foo.COM A_US-ER@foo.bar.org
                         first.last@foo.jp alice+bob@baz.cn]

        valid_addresses.each do |address|
            @user.email = address
            assert @user.valid?, "#{address.inspect} should be valid."
        end
    end

    test "invalid email addresses should not be accepted" do
        invalid_addresses = %w[user@example,com user_at_foo.org user.name@example.
                           foo@bar_baz.com foo@bar+baz.com foo@bar..com]
        invalid_addresses.each do |address|
            @user.email = address
            assert_not @user.valid?, "#{address.inspect} should be invalid."
        end
    end

    test "email addresses should be unique" do
        duplicate_user = @user.dup
        duplicate_user.email = @user.email.upcase
        @user.save
        assert_not duplicate_user.valid?
    end

    test "email addresses should be saved as lower case" do
        mixed_email_address = "hELLo@ExAmple.COm"
        @user.email = mixed_email_address
        @user.save
        assert_equal mixed_email_address.downcase, @user.reload.email
    end

    test "password should be present (nonblank)" do
        @user.password = @user.password_confirmation = " " * 6
        assert_not @user.valid?
    end

    test "password should have a minimum length of 6" do
        @user.password = @user.password_confirmation = "a" * 5
        assert_not @user.valid?
    end

    test "authenticated? should return false for a user with nil digest" do
        assert_not @user.authenticated?('')
    end
end
