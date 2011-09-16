require 'spec_helper'

describe Program do

  describe "an unsaved instance" do
    before do
      @program = Program.new()
      @talk = Talk.new
      @talk.save
      @topic = Topic.new
      @topic.english_title = "Topic title"
      @topic.save
      @place = Place.new
      @place.name = "My Location"
      @place.save
      @translator = Translator.new
      @translator.tibetan_name = "Bob Dobbs"
      @translator.save
    end

    it "should have many talks" do
      @program.new_record?.should be_true
      @program.talks.size == 0
      @program.talks.to_ary.should == []
      @program.talk_ids.should ==[]
      @program.talks << @talk
      @program.talks.map(&:pid).should == [@talk.pid]
      @program.talk_ids.should ==[@talk.pid]
    end

    it "should have note" do
      @program.note = "foo"
      @program.note.should == "foo" 
    end
    it "should have many topics" do
      @program.topics.size == 0
      @program.topics << @topic
      @program.topics.map(&:pid).should == [@topic.pid]
    end

    it "should have a place and a translator" do
      @program.translator = @translator
      @program.place = @place
      @program.translator_id.should == @translator.pid
      @program.place_id.should == @place.pid
    end
    
    describe "association facets" do
      it "should populate location_facet" do
        @program.place = @place
        @program.to_solr["place_facet"].should == [@place.name]
      end
    
      it "should populate topic_facet" do
        @program.topic_ids = [@topic.pid]
        @program.to_solr["topic_facet"].should == [@topic.english_title]
      end
    
      it "should populate text_facet" 
      
    end
    
    after do
      @talk.delete
      @topic.delete
      @place.delete
      @translator.delete
    end
  end

  describe "a saved instance" do
    before do
      @program = Program.new()
      @program.save()
      @talk = Talk.new
      @talk.save
    end
    it "should have many talks once it has been saved" do
      @program.save
      @program.talks << @talk

      @talk.program.pid.should == @program.pid
      @program.talks.reload
      @program.talks.map(&:pid).should == [@talk.pid]


      # @program2 = Program.find(@program.pid)
      # @program2.talks.map(&:pid).should == [@talk.pid]

    
    end
    after do
      @program.delete
      @talk.delete
    end
  end

  describe "Should accept nested attributes for program_texts" do
    it "should respond to method names" do
      @program = Program.new
      @program.should respond_to :program_texts_attributes=
    end
  end



end
