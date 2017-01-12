Feature: Creating microposts
    As a user
    I want to write a micropost
    So that users can see it on my page

    Background: 
        Given a logged in user

    Scenario: Successful micropost creation
        When I visit the homepage
        And I submit a valid micropost
        Then my micropost should show up in my feed
        And I should see a success message
        And other users should be able to see my post

    Scenario: Unsuccessful micropost creation
        When I visit the homepage
        And I submit an invalid micropost
        Then my micropost should not show up in my feed
        And I should see an error message
