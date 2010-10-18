require 'rubygems'
require 'fastercsv'
require "ruby-debug"

class Marpa::CSVImporter 
  
  attr_accessor :headers, :courses
  
  @@header_mappings = {
    "File Name" => ["marpaCore", [:digital_master, :identifier]],
    "Title Tibetan" => ["descMetadata", :tibetan_title],
    "Title English" => ["descMetadata", :title],
    "Author" => ["marpaCore", [:commentary_taught, :author]],
    "Date" => ["descMetadata", :date],
    "Time" => ["marpaCore", [:digital_master, :duration]],
    "Size (MB)" => ["marpaCore", [:digital_master, :file_size]],
    "Location" => ["descMetadata", :spatial], 
    "Access" => ["marpaCore", [:restriction_level]], 
    "Originals" => ["marpaCore", [:physical_instance, :annotation]], 
    "Master" => ["marpaCore", [:digital_master, :location]], 
    "Notes" => ["marpaCore", [:pages]], 
    "Technical Notes" => ["marpaCore", [:technical_note]] # Technical Notes
  }
  
  def self.header_mappings
    @@header_mappings
  end
  
  #Courses:   ["File Name", "Title Tibetan", "Title English", "Author", "Date", "Time", "Size (MB)", "Location", "Access", "Originals", "Master", "Notes", "Notes"]
  #Lectures:  ["Size (MB)", "Location", "Access", "Originals", "Master", "Notes", "Notes"]
  
  def initialize
    @courses = {}
  end
  
  def import(file_path)
    parse_csv(file_path)
    report
    populate_fedora
  end
  
  # Parse CSV file at @file_path
  def parse_csv(file_path)

    # table = FasterCSV.table(file_path, :headers=>true)

    FasterCSV::foreach(file_path, :headers=>true, :skip_blanks=>true) do |row|
      unless row.empty?
        # p row.headers
        # p row.fields
        if row["Type"] == "Course"
          course_name = row["File Name"].strip
          @courses[course_name] = {}
          @courses[course_name][:metadata] = row
        else
          unless row["File Name"].nil?
            ind = row["File Name"].rindex("-") - 1
            course_name = row["File Name"][0..ind]
            @courses[course_name] ||= {}
            @courses[course_name][:lectures] ||= []
            @courses[course_name][:lectures] << row
          end
        end
      end
    end

    # Not the most elegant way to get the headers (which are the same for all rows), but gets the job done
    @headers = courses[courses.keys.first][:metadata].headers
  end
  
  def populate_fedora
    @courses.each_pair do |course_name, course|
      if course[:metadata].nil?
        puts "There's something wrong with the course #{course_name}.  It has no metadata.  #{course.inspect}"
        debugger
      else
        course_fedora = fobject_from_row(course[:metadata], MarpaCourse)
        course_fedora.save
      end
      course[:lectures].each do |lecture_row|
        lecture_fedora = fobject_from_row(lecture_row, MarpaLecture)
        lecture_fedora.add_relationship(:is_part_of, course_fedora)
        lecture_fedora.save
      end
    end
  end
  
  # Create a Fedora object of @model with metadata from @row
  def fobject_from_row(row, model)
    obj = model.new
    new_values = {}
    @@header_mappings.each_pair do |heading, mapping|
      ds_name = mapping.first
      field_pointer = mapping.last
      new_values[ds_name] ||= {}
      begin
        new_values[ds_name][field_pointer] = row[heading]
      rescue
        debugger
      end
    end
    # obj.update_datastream_attributes(new_values)
    obj.datastreams["descMetadata"].update_attributes(new_values["descMetadata"])
    obj.datastreams["marpaCore"].update_indexed_attributes(new_values["marpaCore"])
    obj.datastreams["rightsMetadata"].permissions({:group=>"archivist"}, "edit")
    obj.datastreams["rightsMetadata"].permissions({:group=>"admin"}, "edit")    
    return obj
  end
  

  # Output a report of the parsed courses & lectures
  def report
    p "Courses:"
    courses.each_pair do |course_name, course| 
      if course[:lectures].nil?
        p "!!! #{course_name} has no lectures!"
      else
        p  "#{course_name}: #{course[:lectures].length}"
      end
    end
  end
  
end