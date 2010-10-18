require File.expand_path( File.join( File.dirname(__FILE__), '..','..','spec_helper') )

describe Marpa::CSVImporter  do

  before(:each) do
    @test_importer = Marpa::CSVImporter.new
  end
  
  describe "parse_csv" do
    it "should set up courses and lectures attributes, placing all lectures within their associated courses" do
      @test_importer.parse_csv( File.join(RAILS_ROOT,"lib","marpa","KTGR MP3.csv") )
      @test_importer.courses.length.should == 55
      @test_importer.courses["bzang.spyod.smon.lam-bouddha-1991-psc-t-5c"][:lectures].length.should == 5
      @test_importer.courses["bzang.spyod.smon.lam-bouddha-1991-psc-t-5c"][:lectures].each {|row| row.should be_kind_of(FasterCSV::Row) }
      @test_importer.headers.should == ["File Name", "Type", "Title Tibetan", "Title English", "Author", "Date", "Time", "Size (MB)", "Location", "Access", "Originals", "Master", "Notes", "Technical Notes"]
      @test_importer.courses["bzang.spyod.smon.lam-bouddha-1991-psc-t-5c"][:lectures].first.headers.should == @test_importer.headers
    end
  end
  
  describe "fobject_from_row" do
    it "should create an object of the given model and apply the row's metadata to it" do
      @test_importer.parse_csv( File.join(RAILS_ROOT,"lib","marpa","KTGR MP3.csv") )
      course = @test_importer.courses["shes.bya.mdzod.ch2.3-plaige-1986-psc-te-8c"]
      course_row = course[:metadata]
      lecture_row = course[:lectures][6]
      
      course = @test_importer.fobject_from_row(course_row, MarpaCourse)
      lecture = @test_importer.fobject_from_row(lecture_row, MarpaLecture)
      
      course_dc = course.datastreams["descMetadata"]
      course_dc.tibetan_title_values.should == ["shes bya mdzod chapter 2.3"]
      course_dc.title_values.should == ["Treasury of Knowledge - chapter 2.3"]
      course_dc.date_values.should == ["6-23 April 1986"]
      course_dc.spatial_values.should == ["Kagyü Ling, Plaige, France"]
      
      course_mc = course.datastreams["marpaCore"]
      course_mc.term_values(:digital_master, :identifier).should == ["shes.bya.mdzod.ch2.3-plaige-1986-psc-te-8c"]
      course_mc.term_values(:commentary_taught, :author).should == ["'jam mgon kong sprul blo gros mtha' yas"]
      course_mc.term_values(:digital_master, :duration).should == []
      course_mc.term_values(:digital_master, :file_size).should == ["780"]
      course_mc.term_values(:restriction_level).should == ["Public Access"]
      course_mc.term_values(:physical_instance, :annotation).should == ["8 x 90-minute cassette tapes"]
      course_mc.term_values(:digital_master, :location).should == ["KTGR Audio RAID 1"]
      course_mc.term_values(:pages).should == [""]
      course_mc.term_values(:technical_note).should == [""]
      
      lecture_dc = lecture.datastreams["descMetadata"]
      lecture_dc.tibetan_title_values.should == [" 'phrul gyi lde mig"]
      lecture_dc.title_values.should == ["The Miraculous Key "]
      lecture_dc.date_values.should == ["17-19 April 1986"]
      lecture_dc.spatial_values.should == []
      
      lecture_mc = lecture.datastreams["marpaCore"]
      lecture_mc.term_values(:digital_master, :identifier).should == ["shes.bya.mdzod.ch2.3-plaige-1986-psc-te-8c-7"]
      lecture_mc.term_values(:commentary_taught, :author).should == [""]
      lecture_mc.term_values(:digital_master, :duration).should == ["1:33:19"]
      lecture_mc.term_values(:digital_master, :file_size).should == ["106"]
      lecture_mc.term_values(:restriction_level).should == []
      lecture_mc.term_values(:physical_instance, :annotation).should == [""]
      lecture_mc.term_values(:digital_master, :location).should == [""]
      lecture_mc.term_values(:pages).should == ["17-19.4.86: 'phrul gyi lde mig 17.4: p.64 / 18.4: p.66.2 / 19.4: 3 types of purity in Vajrayana (not in text)"]
      lecture_mc.term_values(:technical_note).should == ["left side only - Tib. Only"]
      
    end
  end
  
end