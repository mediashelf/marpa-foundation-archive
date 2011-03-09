@edit @articles
Feature: Add a new Dataset
  In order to publish a Dataset
  A Depositor
  wants to submit a new Dataset
  
  Scenario: Visit New Dataset Page
    Given I am logged in as "archivist1" 
    And I create a new hydrangea_dataset
    Then I should see "Describe the Dataset"
    And the "Title:" inline edit should be empty