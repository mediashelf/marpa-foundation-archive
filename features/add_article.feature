@add, @article
Feature: Add an Article
  In order to archive my work in the UVA Library
  As a faculty member
  I want to add new articles.

  Scenario: Viewing License options
	Given that I am logged in 
	When I visit the edit article view
	Then I am presented with selection options for the license to apply to the article
