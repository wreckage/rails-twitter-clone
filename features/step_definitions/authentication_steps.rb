Given(/^I visit the login page$/) do
    visit login_path
end

When(/^I submit invalid login information$/) do
    click_button "Log in"
end

Then(/^I should see an error message$/) do
    expect(page).to have_selector('div.alert.alert-danger')
end

Given(/I have an account$/) do
    @user = create_user
end

When(/^I submit valid login information$/) do
    log_in @user
end

Then(/^I should see my profile page$/) do
    expect(page).to have_selector('h1', text: @user.name)
end

Then(/^I should see a log out link$/) do
    expect(page).to have_link(text: /Log out/i, href: logout_path)
end

And(/^I should see a success message$/) do
    expect(page).to have_selector('div.alert.alert-success')
end

