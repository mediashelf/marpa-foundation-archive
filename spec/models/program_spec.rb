require 'spec_helper'

describe Program do

  describe "an unsaved instance" do
    before do
      @program = Program.new()
      @talk = Talk.new
      @talk.save
      @topic = Topic.new
      @topic.save
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
    after do
      @talk.delete
      @topic.delete
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
