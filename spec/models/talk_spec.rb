require 'spec_helper'

describe Talk do


  describe "topics" do
    before do
      @talk = Talk.new
      @topic1 = Topic.new
      @topic1.save
      @topic2 = Topic.new
      @topic2.save
      @topic3 = Topic.new
      @topic3.save
    end
    it "should have an id getter and setter methods" do
      @talk.topic_ids = [@topic1.pid, @topic2.pid]
      @talk.topic_ids.should == [@topic1.pid, @topic2.pid]
      @talk.topics.map(&:pid).should == [@topic1.pid, @topic2.pid]
    end
    it "setter should wipe out previously saved relations" do
      @talk.topic_ids = [@topic1.pid, @topic2.pid]
      @talk.topic_ids = [@topic3.pid]
      @talk.topics.map(&:pid).should == [@topic3.pid]
      
    end
    after do
      @topic1.delete
      @topic2.delete
      @topic3.delete
    end
  end



end
