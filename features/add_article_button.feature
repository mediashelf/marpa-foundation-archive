@create @split_button
Feature: Create Asset or Dataset Split Button
  In order to create new Talks or Courses
  As an editor 
  I want to see a button that will let me create a new Talk or Course
  
  Scenario: Editor views the search results page and sees the add talk button
    Given I am logged in as "archivist@example.com" 
    Given I am on the base search page
    Then I should see "Add a Course" within "ul li"
    
  @overwritten
  Scenario: Non-editor views the search results page and does not see the add talk button
   Given I am on the base search page
   Then I should not see "Add a Talk" 

  @local
  Scenario: Non-editor views the search results page and does see the add talk button
    Given I am on the base search page
    Then I should see "Add a Talk" 
  
