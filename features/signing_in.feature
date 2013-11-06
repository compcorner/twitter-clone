Feature: Signing in

  Scenario: Unsuccessful sign in
    Given a user visits the sign in page
    When she submits invalid sign in information
    Then she should see an error message

  Scenario: Successful sign in
    Given a user visits the sign in page
    And the user has an account
    When the user submits valid sign in information
    Then she should see her profile page
    And she should see a sign out link
