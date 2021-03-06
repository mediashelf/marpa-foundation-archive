Feature: Edit the course
  In order to change the course
  as an editor
  I need to see some editable fields

  Scenario: Editor views the search results page and sees the create buttons
    Given I am logged in as "archivist@example.com" 
    Given I am on the edit page for id fixture:1
    Then I should see "General Teachings on Buddha nature"
    And I should see a link with an id of "edit-title" and a label "edit title"
    And I should see a text field for "Teacher"
    And I should see a text field for "Start Date"
    And I should see a text field for "End Date"
    And I should see a dropdown field for "Location"
    And I should see a link with a class of "addval" and a label "add a location"
    And I should see a checkbox for "Language(s)" with a value of "English"
    And I should see a checkbox for "Language(s)" with a value of "Tibetan"
    And I should see a checkbox for "Language(s)" with a value of "French"
    And I should see a checkbox for "Language(s)" with a value of "Chinese"
    And I should see a dropdown field for "Translator"
    And I should see a link with a class of "addval" and a label "add a translator"
    And I should see a table with a class of "texts" 
    And I should see a link with a class of "addval" and a label "add a text"

  Scenario: Editor views the edit page and submits values
    Given I am logged in as "archivist@example.com" 
    Given I am on the edit page for id fixture:1
    When I fill in the following:
       |Teacher  |Marco Polo |
    And I press "Save changes"
    Then I should see "Your changes have been saved" within ".notice"
    When I go to the show document page for fixture:1 in browse context
    Then the "Teacher" term should contain "Marco Polo"
    

