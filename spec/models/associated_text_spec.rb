require File.join( File.dirname(__FILE__), "../spec_helper" )

describe Marpa::Datastreams::AssociatedText do
  before :each do
    @datastream = Marpa::Datastreams::AssociatedText.from_xml( fixture("marpa_lecture/text-associations-definitive-meaning.xml") )
  end
  describe "to_solr" do
    before(:each) do
      @solr_doc = @datastream.to_solr
    end
    it "should not need any indexing" do
      @solr_doc.should == {}
    end
  end
  describe "the terminology" do
    before(:each) do
    end
    it "should have stuff" do
      @datastream.term_values(:nature).should == ["root"]
      @datastream.term_values(:chapter).should == ["1"]
      @datastream.term_values(:sections).should == ["1-5"]
      @datastream.term_values(:pages).should == ['11-24']
    end
  end
end
