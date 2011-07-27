require File.join( File.dirname(__FILE__), "../spec_helper" )

describe Marpa::MarpaDCDatastream do
  before :each do
    @datastream = Marpa::MarpaDCDatastream.from_xml( fixture("marpa_course/course_dc.xml") )
  end
  describe "to_solr" do
    before(:each) do
      @solr_doc = @datastream.to_solr
    end
    it "should not need any indexing" do
      puts "Solr doc: #{@solr_doc.inspect}"
      @solr_doc.should have_key :start_date
    end
  end
  describe "the terminology" do
    before(:each) do
    end
    it "should have stuff" do
#      @datastream.term_values(:date).should == ['2010-05-28']
      @datastream.term_values(:start_date).should == ['2010-05-28']
      @datastream.term_values(:end_date).should == ['2010-06-02']

    end
  end
  describe "generating xml" do
    before :each do
      @new = Marpa::MarpaDCDatastream.new()
    end
    it "should generate xml with the date encoded as ical" do
      @new.update_indexed_attributes({['start_date']=>['1991-02-28']})
      @new.update_indexed_attributes({['end_date']=>['1991-02-28']})
      @new.find_by_terms(:start_date).to_xml.should == ['<ical:dtstart>1991-02-28</ical:dtstart>']
      @new.find_by_terms(:end_date).to_xml.should == ['<ical:dtend>1991-02-28</ical:dtend>']
      @new.find_by_terms(:date).to_xml.should == '<ical:Vevent><ical:dtstart>0000-00-00</ical:dtstart><ical:dtend></ical:dtend></ical:Vevent>'
    end
  end
end
