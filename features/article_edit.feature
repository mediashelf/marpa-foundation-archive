@edit @articles
Feature: Edit a document
  In order to [goal]
  [stakeholder]
  wants [behaviour]
  
  @overwritten
  Scenario: Visit Document Edit Page
    Given I am logged in as "archivist1" 
    And I am on the edit document page for hydrangea:fixture_mods_article1 
    Then I should see an inline edit containing "ARTICLE TITLE"
  
  @local
  Scenario: Visit Document Edit Page
    Given I am logged in as "archivist1" 
    And I am on the edit document page for libra-oa:1
    Then I should see "The Smallest Victims of the " within "#title_fieldset"

  # the mockups for Libra did not have browse/edit buttons
  @overwritten
  Scenario: Viewing browse/edit buttons
    Given I am logged in as "archivist1" 
    And I am on the edit document page for hydrangea:fixture_mods_article1
    Then I should see a "span" tag with a "class" attribute of "edit-browse"

  # the mockups for Libra did not have a delete confirmation
  @overwritten
  Scenario: Delete Confirmation on Edit Page
    Given I am logged in as "archivist1" 
    And I am on the edit document page for hydrangea:fixture_mods_article1 
    Then I should see a "div" tag with an "id" attribute of "delete_dialog_container"
    And I should see "Permanently delete"

