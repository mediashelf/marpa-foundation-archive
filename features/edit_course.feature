Feature: Edit the course
  In order to change the course
  as an editor
  I need to see some editable fields

  Scenario: Editor views the search results page and sees the create buttons
    Given I am logged in as "archivist@example.com" 
    Given I am on the the edit page for id marpa:1
    Then I should see "General Teachings on Buddha nature"
    And I should see a link with an id of "edit-title" and a label "edit title"
    And I should see a text field for "Teacher"
    And I should see a text field for "Start Date"
    And I should see a text field for "End Date"
    And I should see a dropdown field for "Location"
    And I should see a link with a class of "addval" and a label "add a location"
    And I should see checkboxes for "Language(s)"
    And I should see a dropdown field for "Translator"
    And I should see a link with a class of "addval" and a label "add a translator"
    And I should see a table with a class of "texts" 
    And I should see a link with a class of "addval" and a label "add a text"

