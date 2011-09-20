module Marpa
  module Datastreams
    class Paperclip < ActiveFedora::NokogiriDatastream
  
      set_terminology do |t|
        t.root(:path=>"paperclip", :xmlns=>'http://yourmediashelf.com/schemas/paperclip/v0')
        t.file {
          t.file_name(:path=>"fileName")
          t.content_type(:path=>"contentType")
          t.file_size(:path=>"fileSize")
          t.file_updated_at(:path=>"uploadedAt")
        }
        t.file_file_name(:proxy=>[:file,:file_name])
        t.file_content_type(:proxy=>[:file,:content_type])
        t.file_file_size(:proxy=>[:file,:file_size])
        t.file_updated_at(:proxy=>[:file,:file_updated_at])
      end
  
      def self.xml_template
        builder = Nokogiri::XML::Builder.new do |xml|
          xml.paperclip("xmlns"=>"http://yourmediashelf.com/schemas/paperclip/v0") {
            xml.file {
              xml.contentType
              xml.fileSize
              xml.uploadedAt
            }
          }
        end
        return builder.doc
      end
    end
  end
end