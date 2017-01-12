When(/^I visit the homepage$/) do
    visit root_path
end

And(/^I submit a valid micropost$/) do
    @content = "Hello world!"
    fill_in "micropost_content", with: @content
    click_button "Post"
end

Then(/^my micropost should show up in my feed$/) do
    expect(page).to have_selector('span.content', text: @content)
end

And(/^I submit an invalid micropost$/) do
    fill_in "micropost_content", with: ""
    click_button "Post"
end

Then(/^my micropost should not show up in my feed$/) do
    expect(page).not_to have_selector('span.content', text: @content)
end

And(/^other users should be able to see my post$/) do
    other_user = create_user name: "other user", email: "other@example.com"
    log_in other_user
    expect(page).to have_selector('h1', text: other_user.name)
    visit user_path @user
    expect(page).to have_selector('span.content', text: @content)
end
