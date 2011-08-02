require File.join( File.dirname(__FILE__), "../spec_helper" )

describe Marpa::Datastreams::Place do
  before :each do
    @datastream = Marpa::Datastreams::Place.from_xml( fixture("marpa_location/place.xml") )
  end
  describe "to_solr" do
    before(:each) do
      @solr_doc = @datastream.to_solr
    end
    it "should not need any indexing" do
      @solr_doc['name_t'].should == ['CodeSpace']
      @solr_doc['description_t'].should == ['A good place to find coders']
    end
  end
  describe "the terminology" do
    before(:each) do
    end
    it "should have stuff" do
      @datastream.term_values(:name).should == ["CodeSpace"]
      @datastream.term_values(:description).should == ["A good place to find coders"]
      @datastream.term_values(:latitude).should == ['44.949955']
      @datastream.term_values(:longitude).should == ['-93.285441']
    end
  end
end

describe Place do
  it "Should save and recall values" do
      @obj = Place.new
      @obj.datastreams['placeInfo'].update_indexed_attributes([:name] => 'Home')
      @obj.save
      @obj.datastreams['placeInfo'].term_values(:name).first.should == 'Home'
  end
  it "Should save and recall values when using setter shortcuts" do
      @obj = Place.new(:name=>'The store')
      @obj.save
      @obj.datastreams['placeInfo'].term_values(:name).first.should == 'The store'
  end

  it "Should save and recall values when using getter shortcuts" do
      @obj = Place.new
      @obj.datastreams['placeInfo'].update_indexed_attributes([:name] => 'The beach')
      @obj.save
      @obj.name.should == 'The beach'
  end

  it "Should parse map_coordinates" do
      @obj = Place.new(:map_coordinates=>'44.95,-93.28')
      @obj.save
      @obj.datastreams['placeInfo'].term_values(:latitude).first.should == '44.95'
      @obj.datastreams['placeInfo'].term_values(:longitude).first.should == '-93.28'
  end
  it "Should print map_coordinates" do
      @obj = Place.new()
      @obj.datastreams['placeInfo'].update_indexed_attributes([:latitude] => '44.95')
      @obj.datastreams['placeInfo'].update_indexed_attributes([:longitude] => '-93.28')
      @obj.save
      @obj.map_coordinates.should == '44.95,-93.28'
  end
end

