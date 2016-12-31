require 'test_helper'

class UsersEditTest < ActionDispatch::IntegrationTest
    def setup
        @user = users(:john)
    end

    test "unsuccessful edit" do
        log_in_as(@user)
        get edit_user_path(@user)
        assert_template 'users/edit'
        patch user_path(@user), params: { user: { name: "",
                                                  email: "bar@invalid",
                                                  password: "bar",
                                                  password_confirmation: "foo" } }
        assert_template 'users/edit'
    end

    test "successful edit with friendly forwarding" do
        get edit_user_path(@user)
        log_in_as(@user)
        assert_redirected_to edit_user_path(@user)
        #assert_select 'form[action="/signup"]'
        follow_redirect!
        assert_select "form[action='#{user_path(@user)}']"
        name = "Foo Bar"
        email = "foo@bar.com"
        patch user_path(@user), params: { user: { name: name,
                                                  email: email,
                                                  password: "",
                                                  password_confirmation: "" } }
        assert_not flash.empty?
        assert_redirected_to @user
        @user.reload
        assert_equal name, @user.name
        assert_equal email, @user.email
        assert session[:forwarding_url].nil?
    end
end
