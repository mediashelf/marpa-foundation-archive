require 'marpa/marpa_dc_datastream'
module Marpa
class MarpaCore < ActiveFedora::NokogiriDatastream
  
  set_terminology do |t|
    t.root(:path=>"marpa_core", :xmlns=>"http://yourmediashelf.com/schemas/marpa-core/v0")
    t.restriction_level(:path=>"accessRestrictionLevel") # pbcoreAudienceLevel
    t.restriction_instructions(:path=>"accessRestrictionInstructions")
    t.commentary_taught(:path=>"subject", :type=>"commentary") {
      t.author
      t.title
    }
    t.originally_recorded_by(:path=>"contributor", :attributes=>{:role=>"operator"}) # contributor with contributorRole of operator
    t.instance_{
      t.identifier
      t.location
      t.annotation
      t.file_size(:path=>"fileSize")
      t.duration
    }
    t.physical_instance(:ref=>:instance, :attributes=>{:type=>"physical"})
    t.original_instance(:ref=>:instance, :attributes=>{:type=>"original"})
    t.digital_master(:ref=>:instance, :attributes=>{:type=>"digital"}) # instantiation/instantiationDigital
    # t.original_filename(:proxy=>[:digital_master, :identifier]) # Proxies don't work at the root of Terminologies :(    
    t.keywords
    t.note
    t.technical_note(:path=>"note", :attributes=>{:type=>"technical"})
    t.pages(:path=>"note", :attributes=>{:type=>"pages"})
  end
  
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.marpa_core(:version=>"3.3", "xmlns:xlink"=>"http://www.w3.org/1999/xlink",
         "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
         "xmlns"=>"http://yourmediashelf.com/schemas/marpa-core/v0") {
         xml.description("This xml is loosely imitating PBCore as a placeholder until we implement support for real PBCore XML")
         xml.subject(:type=>"commentary") {
           xml.author
           xml.title
         }
         xml.contributor(:role=>"operator")
         xml.instance_(:type=>"digital") {
           xml.identifier
           xml.location
         }
         xml.instance_(:type=>"physical") {
           xml.identifier
           xml.location
           xml.annotation
         }
         xml.keywords()
         xml.note(:type=>"pages")
         xml.note(:type=>"technical")
      }
    end
    return builder.doc
  end
  
end
end
