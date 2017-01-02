require 'test_helper'

class UsersShowTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:zoe)
    end

    test "non-activated users should redirect home" do
        assert_not @user.activated?
        get user_path(@user)
        assert_redirected_to root_url
    end
end
