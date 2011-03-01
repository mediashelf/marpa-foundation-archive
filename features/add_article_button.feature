@create @split_button
Feature: Create Asset or Dataset Split Button
  In order to create new Assets or Datasets
  As an editor 
  I want to see a button that will let me create a new Article or Dataset
  
  Scenario: Editor views the search results page and sees the add article button
    Given I am logged in as "archivist1" 
    Given I am on the base search page
    Then I should see "Add an article" within "ul.add_sub_menu"
    
  # FOR CORE
  @overwritten
  Scenario: Non-editor views the search results page and does not see the add article button
   Given I am on the base search page
   Then I should not see "Add an article" 

# FOR UVa
  @local
  Scenario: Non-editor views the search results page and does see the add article button
    Given I am on the base search page
    Then I should see "Add an article" 
  
