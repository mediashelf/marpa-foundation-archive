# encoding: utf-8
require "spec_helper"

describe Marpa::MarpaDCDatastream do
  before :each do
    @datastream = Marpa::MarpaDCDatastream.from_xml( fixture("marpa_course/course_dc.xml") )
    @text_dc = Marpa::MarpaDCDatastream.from_xml( fixture("marpa_text/text_dc.xml") )
  end
  describe "to_solr" do
    before(:each) do
      @solr_doc = @datastream.to_solr
    end
    it "should not need any indexing" do
      puts "Solr doc: #{@solr_doc.inspect}"
      @solr_doc.should have_key "start_date_t"
    end
  end
  describe "the terminology" do
    before(:each) do
    end
    it "should have stuff" do
      @datastream.start_date.should == ['2010-05-28']
      @datastream.end_date.should == ['2010-06-02']
    end
    
    it "should work with cpf scriptCode and transliteration values" do
      @text_dc.english_title.should == ['General Teachings on Buddha nature']
      @text_dc.tibetan_title.should == ['ཐེག་པཆེན་པོ་རྒྱུད་བླ་མའི་བསྟན་བཅོས']
      @text_dc.wylie_title.should == ['thek bChen po rgyud bla mai bstan bcos']
      @text_dc.marpa_transliteration_title.should == ['thek chenpo gyu la mai ten chö']
      @text_dc.sanskrit_title.should == ['Uttaratantra']
      @text_dc.sanskrit_diacrit_title.should == ['Ratnagotravibhāgavyākhyā/ Mahāyānottaratantrashāstravyākhyā']      
    end
  end
  describe "generating xml" do
    before :each do
      @new = Marpa::MarpaDCDatastream.new(nil, nil)
    end
    it "should generate xml with scriptcode and transliteration set" do
      # !! Cheating !! these fields are prefabricated in the xml template file
      @new.update_indexed_attributes({['tibetan_title']=>['my tibetan'],['english_title']=>['my english'], ['wylie_title']=>['my wylie'], ['marpa_transliteration_title']=>['my phonetic']})
      @new.find_by_terms(:tibetan_title).to_xml.should == "<title xml:lang=\"tib\" cpf:scriptCode=\"Tibt\">my tibetan</title>"
      @new.find_by_terms(:wylie_title).to_xml.should == "<title xml:lang=\"tib\" cpf:scriptCode=\"Latn\" cpf:transliteration=\"wylie\">my wylie</title>"
      @new.find_by_terms(:marpa_transliteration_title).to_xml.should == "<title xml:lang=\"tib\" cpf:scriptCode=\"Latn\" cpf:transliteration=\"marpa\">my phonetic</title>"
    end
    it "should generate xml with the date encoded as ical" do
      @new.update_indexed_attributes({['start_date']=>['1991-02-28']})
      @new.update_indexed_attributes({['end_date']=>['1991-02-28']})
      @new.find_by_terms(:start_date).to_xml.should == '<ical:dtstart>1991-02-28</ical:dtstart>'
      @new.find_by_terms(:end_date).to_xml.should == '<ical:dtend>1991-02-28</ical:dtend>'
      @new.find_by_terms(:date).to_xml.should be_equivalent_to '<date><ical:Vevent><ical:dtstart>1991-02-28</ical:dtstart><ical:dtend>1991-02-28</ical:dtend></ical:Vevent></date>'
    end
  end
end
