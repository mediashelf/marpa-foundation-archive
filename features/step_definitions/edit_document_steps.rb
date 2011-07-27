require File.expand_path(File.join(File.dirname(__FILE__), "..", "support", "paths"))

Then /^I should see a link with an id of "([^"]*)" and a label "([^"]*)"$/ do |id, text|
  page.should have_selector("a##{id}", :text=>text)
end


Then /^I should see a text field for "([^"]*)"$/ do |label_text|
  label = find('label', :text=>label_text)
  page.should have_selector("input##{label[:for]}")
end

Then /^I should see a dropdown field for "([^"]*)"$/ do |label_text|
  label = find('label', :text=>label_text)
  page.should have_selector("select##{label[:for]}")
end

Then /^I should see a link with a class of "([^"]*)" and a label "([^"]*)"$/ do |html_class, link_text|
  page.should have_selector("a.#{html_class}", :text=>link_text)
end

Then /^I should see a checkbox for "([^"]*)" with a value of "([^"]*)"$/ do |field, label_text|
  label = find('label', :text=>label_text)
  page.should have_selector("input##{field}_#{label[:for]}[type=checkbox]")
end

Then /^I should see a table with a class of "([^"]*)"$/ do |html_class|
  page.should have_selector("table.#{html_class}")
end

