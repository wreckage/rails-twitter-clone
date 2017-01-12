Given(/^a logged in user/i) do
    @user = create_user
    log_in @user
end
