require 'spec_helper'

describe Topic do
  before do
    @topic = Topic.new
  end
  it "should belong to many programs" do
    @topic.programs = [Program.new, Program.new]
    @topic.programs.size.should == 2
    
  end
end
