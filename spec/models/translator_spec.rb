require File.join( File.dirname(__FILE__), "../spec_helper" )

describe Translator do
  it "Should save and recall values" do
      @obj = Translator.new(:tibetan_name=>'Ari Goldfield')
      @obj.save
      @obj.tibetan_name.should == 'Ari Goldfield'
  end
end

