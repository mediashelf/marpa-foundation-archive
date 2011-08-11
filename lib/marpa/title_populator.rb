# require "ruby-debug"

class Marpa::TitlePopulator
  
  # find all courses
  # for each course, store the filename (ie. shes.bya.mdzod.ch6.3-eskdalemuir-1984-psc-te-12c-1) & find all teachings
  # for each teaching, get the diff of the teaching filename and the course filename, remove "-" then use that as the talk_number
  #   set title to "#{course_title}: Talk #{talk_number}"
  #   put a link to the talk in the course contentMetadata
  def populate_titles
    courses = MarpaCourse.find(:all, :rows=>1000) 
    courses.each do |course|
      begin
        course_filename = course.datastreams["marpaCore"].term_values(:digital_master, :identifier).first
        # course_title = course.datastreams["descMetadata"].term_values(:title_info, :main_title).first
        course_title = course.datastreams["descMetadata"].term_values(:english_title).first
        if course_title.nil? || course_title.empty?
          course_title = course_filename
          course.datastreams["descMetadata"].update_indexed_attributes([:english_title]=>course_title)
          course.save
        end
        course.parts(:rows=>100).each do |talk|
          talk_filename = talk.datastreams["marpaCore"].term_values(:digital_master, :identifier).first
          talk_name = talk_filename.gsub(course_filename+"-", "")
          talk_title = "#{course_title}: Talk #{talk_name}"
          talk.datastreams["descMetadata"].update_indexed_attributes([:english_title]=>course_title)
          talk.save
        end
      rescue => e
        puts "!!! Failed to fully update #{course.pid} and its parts.  Ran into #{e.class} error. #{e.message}. #{e.backtrace}"
      end
    end
  end
  
end