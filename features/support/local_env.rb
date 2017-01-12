Cucumber::Rails::World.class_eval do
    # Log a user in by visiting the log in page
    def log_in(user, options = {})
      email = options.has_key?(:email) ? options[:email] : user.email
      password = options.has_key?(:password) ? options[:password] : user.password
      visit login_path
      fill_in "Email",    with: email
      fill_in "Password", with: password
      click_button "Log in"
      # Sign in when not using Capybara as well.
      cookies[:remember_token] = user.remember_token
    end

    def create_user
        User.create(
            name: "example", email: "example@example.com", 
            password: "foobar", password_confirmation: "foobar",
            activated: true
        )
    end
end
