require 'rubygems'
require 'fastercsv'
require "ruby-debug"

file_path = "KTGR MP3.csv"

#["File Name", "Title Tibetan", "Title English", "Author", "Date", "Time", "Size (MB)", "Location", "Access", "Originals", "Master", "Notes", "Notes"]
#["Size (MB)", "Location", "Access", "Originals", "Master", "Notes", "Notes"]


header_mappings = {
  "File Name" => ["MarpaCourse", :original_filename],
  "Title Tibetan" => ["descMetadata", [:tibetan_title]],
  "Title English" => ["descMetadata", [:title]],
  "Author" => ["descMetadata", [:author]],
  "Date" => ["descMetadata", [:date]],
  "Time" => ["descMetadata", [:date_recorded]],

}

courses = []
lectures = {}
# table = FasterCSV.table(file_path, :headers=>true)

FasterCSV::foreach(file_path, :headers=>true, :skip_blanks=>true) do |row|
  unless row.empty?
    # p row.headers
    # p row.fields
    if row["Type"] == "Course"
      courses << row
    else
      unless row["File Name"].nil?
        ind = row["File Name"].rindex("-") - 1
        course_name = row["File Name"][0..ind]
        lectures[course_name] ||= []
        lectures[course_name] << row
      end
    end
  end
end

# Not the most elegant way to get the headers (which are the same for all rows), but gets the job done
headers = courses.first.headers

p "Courses:"
courses.each do |course| 
  course_name = course["File Name"].strip
  if lectures[course_name].nil?
    debugger
    p "!!! #{course_name} has no lectures!"
  else
    p  "#{course_name}: #{lectures[course_name].length}"
  end
end