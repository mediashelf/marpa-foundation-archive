require File.join( File.dirname(__FILE__), "../spec_helper" )

describe Marpa::Datastreams::AssociatedTexts do
  before :each do
    @datastream = Marpa::Datastreams::AssociatedTexts.from_xml( fixture("marpa_lecture/text-associations-definitive-meaning.xml") )
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
      @datastream.term_values(:associated_text).size.should == 2 
      @datastream.term_values({:associated_text=>0}, :nature).should == ["root"]
      @datastream.term_values({:associated_text=>1}, :nature).should == ["commentary"]
      @datastream.term_values({:associated_text=>0}, :chapter).should == ["1"]
      @datastream.term_values({:associated_text=>1}, :chapter).should == []
      @datastream.term_values({:associated_text=>0}, :sections).should == ["1-5"]
      @datastream.term_values({:associated_text=>1}, :sections).should == []
      @datastream.term_values({:associated_text=>0}, :pages).should == []
      @datastream.term_values({:associated_text=>1}, :pages).should == ["22-55"]
      @datastream.term_values({:associated_text=>0}, :text).should == ['marpa:55']
      @datastream.term_values({:associated_text=>1}, :text).should == ["marpa:27"]

    end
  end
end
