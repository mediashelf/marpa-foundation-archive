require 'spec_helper'

describe ProgramText do
  describe "a saved instance" do
    before do
      @program = Program.new
      @program.save
      @text = Text.new
      @text.save
    end
    it "Should set text and program" do 
      @program_text = ProgramText.new(:text=>@text, :program=>@program)
      @program_text.save
      pt = ProgramText.find(@program_text.pid)
      pt.text.pid.should == @text.pid
      pt.program.pid.should == @program.pid
    end

    after do
      @program_text.delete
      @program.delete
      @text.delete
    end
  end
  it "Should have metadata" do
     @program_text = ProgramText.new
     @program_text.descMetadata.should_not be_nil 
     @program_text.nature = "root"
     @program_text.nature.should == 'root'
     @program_text.chapter = "chapter the first"
     @program_text.chapter.should == 'chapter the first'
     @program_text.sections = "A,B and D"
     @program_text.sections.should == 'A,B and D'
     @program_text.pages = "1-5"
     @program_text.pages.should == '1-5'
  end
  it "should have an id same as pid" do
    @program_text = ProgramText.new
    @program_text.id.should == @program_text.pid
  end
end
