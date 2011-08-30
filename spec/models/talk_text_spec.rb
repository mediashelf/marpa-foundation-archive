require 'spec_helper'

describe TalkText do
  describe "a saved instance" do
    before do
      @talk = Talk.new
      @talk.save
      @text = Text.new
      @text.save
    end
    it "Should set text and talk" do 
      @talk_text = TalkText.new(:text=>@text, :talk=>@talk)
      @talk_text.save
      pt = TalkText.find(@talk_text.pid)
      pt.text.pid.should == @text.pid
      pt.talk.pid.should == @talk.pid
    end

    after do
      @talk_text.delete
      @talk.delete
      @text.delete
    end
  end
  it "Should have metadata" do
     @talk_text = TalkText.new
     @talk_text.descMetadata.should_not be_nil 
     @talk_text.nature = "root"
     @talk_text.nature.should == 'root'
     @talk_text.chapter = "chapter the first"
     @talk_text.chapter.should == 'chapter the first'
     @talk_text.sections = "A,B and D"
     @talk_text.sections.should == 'A,B and D'
     @talk_text.pages = "1-5"
     @talk_text.pages.should == '1-5'
  end
  it "should have an id same as pid" do
    @talk_text = TalkText.new
    @talk_text.id.should == @talk_text.pid
  end
end

