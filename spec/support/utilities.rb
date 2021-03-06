module Utilities
    # Log a user in by visiting the log in page
    def log_in(user)
      visit login_path
      fill_in "Email",    with: user.email
      fill_in "Password", with: "password"
      click_button "Log in"
      # Sign in when not using Capybara as well.
      cookies[:remember_token] = user.remember_token
    end
end
