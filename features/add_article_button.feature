@create @split_button
Feature: Create Asset Button
  In order to create new Talks or Courses
  As an editor 
  I want to see a button that will let me create a new Talk or Course
  
  Scenario: Editor views the search results page and sees the create buttons
    Given I am logged in as "archivist@example.com" 
    Given I am on the base search page
    Then I should see a link to "new marpa_course page" with label "Add a Course"
    And I should see a link to "new marpa_lecture page" with label "Add a Talk"
   
  Scenario: Non-editor views the search results page and sees create buttons 
   Given I am logged in as "foo@example.com" 
   Given I am on the base search page
   Then I should see a link to "new marpa_course page" with label "Add a Course"
   And I should see a link to "new marpa_lecture page" with label "Add a Talk"

  
