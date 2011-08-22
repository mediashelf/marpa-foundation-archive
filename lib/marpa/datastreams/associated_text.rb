module Marpa
  module Datastreams
    class AssociatedText < ActiveFedora::NokogiriDatastream
      set_terminology do |t|
        t.root(:path=>"associatedText", :xmlns=>"http://yourmediashelf.com/schemas/marpaTextAssociation/v0", :index_as=>[:not_searchable])
        t.nature(:index_as=>[:not_searchable])
        t.chapter(:index_as=>[:not_searchable])
        t.sections(:index_as=>[:not_searchable])
        t.pages(:index_as=>[:not_searchable])
      end

      def self.xml_template 
        Nokogiri::XML::Document.parse(
            "<associatedText xmlns=\"http://yourmediashelf.com/schemas/marpaTextAssociation/v0\">
              <nature></nature>
              <chapter></chapter>
              <sections></sections>
              <pages></pages>
            </associatedText>")
      end
    end
  end
end
