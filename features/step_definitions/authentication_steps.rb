Given(/^a user visits the login page$/) do
    visit login_path
end

When(/^they submit invalid login information$/) do
    click_button "Log in"
end

Then(/^they should see an error message$/) do
    expect(page).to have_selector('div.alert.alert-danger')
end

Given(/^the user has an account$/) do
    @user = create_user
end

When(/^the user submits valid login information$/) do
    log_in @user
end

Then(/^they should see their profile page$/) do
    expect(page).to have_selector('h1', text: @user.name)
end

Then(/^they should see a log out link$/) do
    expect(page).to have_link(text: /Log out/i, href: logout_path)
end
