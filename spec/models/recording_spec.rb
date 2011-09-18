require 'spec_helper'

describe Recording do
  before(:each) do
    @recording = Recording.new
  end
  it "should have marpaCore metadata" do
    # 
    fields = %w{document_identifier originally_recorded_by contributed_by note duration restriction_level restriction_instructions}
    fields = fields + %w{physical_instance_format physical_instance_location physical_instance_notes}
    fields.each do |field|
      @recording.send("#{field}=".to_sym, "#{field} test value")
      @recording.datastreams["marpaCore"].term_values(field.to_sym).should == ["#{field} test value"]
    end
  end
  it "should respond to document_identifier" do
    @recording.should respond_to(:document_identifier)
  end
end
