Spec::Matchers.define :have_solr_fields do |expected|
  match do |actual|
    inspected = actual.inspect
    result = false
    expected.each_pair do |field_name, field_value|
      /<Solr::Field.*@name=\"#{field_name.to_s}\".*, @value=\"#{field_value}\".*>/
      result = inspected.include?("@name=\"#{field_name.to_s}\", @boost=nil, @value=\"#{field_value}\"") || \
              inspected.include?("@value=\"#{field_value}\", @boost=nil, @name=\"#{field_name.to_s}\"") || \
              inspected.include?("@boost=nil, @value=\"#{field_value}\", @name=\"#{field_name.to_s}\"") || \
              inspected.include?("@boost=nil, @name=\"#{field_name.to_s}\", @value=\"#{field_value}\"")      
    end
    result
  end
  
  failure_message_for_should do |actual|
    "expected that #{actual.inspect} would contain a field for #{expected.inspect}"
  end

  failure_message_for_should_not do |actual|
    "expected that #{actual.inspect} would not contain a field for #{expected.inspect}"
  end
end