require File.join( File.dirname(__FILE__), "../spec_helper" )

describe Marpa::Datastreams::EacCpf do
  before :each do
    @datastream = Marpa::Datastreams::EacCpf.from_xml( fixture("marpa_author/eac-cpf-maitreya.xml") )
  end
  describe "to_solr" do
    before(:each) do
      @solr_doc = @datastream.to_solr
    end
    it "should not need any indexing" do
      @solr_doc.should have_key 'tbrc_id_t'
      @solr_doc.should have_key 'tibetan_name_t'
      @solr_doc.should have_key 'wylie_name_t'
      @solr_doc.should have_key 'phonetic_name_t'
      @solr_doc["tbrc_id_t"].should == ['P264']
      @solr_doc["tibetan_name_t"].should == ['འཇམ་མགོན་ཀོང་སྤྲུལ་བློ་གྲོས་མཐའ་ཡས']
      @solr_doc["wylie_name_t"].should == ["'jam mgon kong sprul blo gros mtha' yas"]
      @solr_doc["phonetic_name_t"].should == ['Jamgon Kongtrul Lodrö Thaye']
    end
  end
  describe "the terminology" do
    before(:each) do
    end
    it "should have stuff" do
      @datastream.term_values(:tibetan_name).should == ['འཇམ་མགོན་ཀོང་སྤྲུལ་བློ་གྲོས་མཐའ་ཡས']
      @datastream.term_values(:phonetic_name).should == ['Jamgon Kongtrul Lodrö Thaye']
      @datastream.term_values(:wylie_name).should == ["'jam mgon kong sprul blo gros mtha' yas"]
    end
  end

  describe "generating xml" do
    before :each do
      @new = Marpa::Datastreams::EacCpf.new()
    end
    it "should generate xml with two attributes on the name" do
      @new.update_indexed_attributes({['tibetan_name']=>['steve']})
      @new.find_by_terms(:tibetan_name).to_xml.should == '<part>steve</part>'
    end
  end
end
