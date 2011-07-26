Feature: Edit the course
  In order to change the course
  as an editor
  I need to see some editable fields

  Scenario: Editor views the search results page and sees the create buttons
    Given I am logged in as "archivist@example.com" 
    Given I am on the the edit page for id marpa:1
    Then I should see "General Teachings on Buddha nature"
    And I should see a link with an id of "edit-title" and a label "edit title"

