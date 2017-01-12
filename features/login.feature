Feature: Logging in

  Scenario: Unsuccessful login
    Given a user visits the login page
    When they submit invalid login information
    Then they should see an error message

  Scenario: Successful login
    Given a user visits the login page
      And the user has an account
    When the user submits valid login information
    Then they should see their profile page
      And they should see a log out link
