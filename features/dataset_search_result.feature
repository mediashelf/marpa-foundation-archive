@catalog @datasets
Feature: Dataset Search Result
  As a user
  In order to find datasets
  I want to see appropriate information about datasets in a search result

  Scenario: Viewing search results
    Given I am on the home page
    And I fill in "q" with "tiger shark"
    When I press "search"
    Then I should see a link to "the show document page for hydrangea:fixture_mods_dataset1"
    And I should see "2010-08-14 4:41a"
