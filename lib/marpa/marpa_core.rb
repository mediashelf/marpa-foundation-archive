require 'marpa/marpa_dc_datastream'
module Marpa
class MarpaCore < ActiveFedora::NokogiriDatastream
  
  set_terminology do |t|
    t.root(:path=>"marpa_core", :xmlns=>"http://yourmediashelf.com/schemas/marpa-core/v0")
    t.restriction_level(:path=>"accessRestrictionLevel") # pbcoreAudienceLevel
    t.restriction_instructions(:path=>"accessRestrictionInstructions")
    t.identifier
    t.annotation
    t.commentary_taught(:path=>"subject", :type=>"commentary") {
      t.author
      t.title
    }
    t.originally_recorded_by(:path=>"contributor", :attributes=>{:role=>"operator"}) # contributor with contributorRole of operator
    t.contributed_by(:path=>"publisher") 
    t.instantiation{
      t.identifier
      t.location
      t.annotation
      t.file_size(:path=>"fileSize")
      t.duration
      t.digital_format(:path=>"instantiationDigital")
      t.physical_format(:path=>"instantiationPhysical")
      t.ebu_format(:path=>"instantiationPhysical", :attributes=>{:source=>"EBU Storage Media Type Code", :ref=>"http://www.ebu.ch/metadata/cs/web/ebu_StorageMediaTypeCode_p.xml.htm"})
    }
    t.physical_instance(:ref=>:instantiation, :attributes=>{:type=>"physical"})
    t.original_instance(:ref=>:instantiation, :attributes=>{:type=>"original"})
    t.digital_instance(:ref=>:instantiation, :attributes=>{:type=>"digital"}) # instantiation/instantiationDigital
    
    # t.original_filename(:proxy=>[:digital_master, :identifier]) # Proxies don't work at the root of Terminologies :(    
    t.keywords

    t.technical_annotation(:path=>"annotation", :attributes=>{:type=>"technical"})
    
    # Proxy Terms
    t.duration(:proxy=>[:physical_instance, :duration])
    t.physical_instance_format(:proxy=>[:physical_instance, :ebu_format])
    t.physical_instance_location(:proxy=>[:physical_instance, :location])
    t.physical_instance_notes(:proxy=>[:physical_instance, :annotation])
    t.document_identifier(:proxy=>[:marpa_core, :identifier])
    t.note(:proxy=>[:marpa_core, :annotation])
    t.technical_note(:proxy=>[:marpa_core, :technical_annotation])
    
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
         xml.instantiation(:type=>"digital") {
           xml.identifier
           xml.location
         }
         xml.instantiation(:type=>"physical") {
           xml.identifier
           xml.location
           xml.annotation
           xml.duration
         }
         xml.keywords()
         xml.annotation(:type=>"technical")
      }
    end
    return builder.doc
  end
  
  # Selected codes from http://www.ebu.ch/metadata/cs/web/ebu_StorageMediaTypeCode_p.xml.htm
  # @example
  #   {"CCA" => "Compact Cassette format analogue audio tape, cassette",
  #    "CDA" => "Compact Disk Audio digital audio disk"}
  # @return [Hash]
  def self.ebu_storage_media_codes
    {"CCA" => "Cassette Tape (Compact Cassette format analogue audio tape)",
    "CDA" => "Audio CD (Compact Disk digital audio disk)",
    "CDR" => "Recordable CD digital data disk",
    "DA2" => "DAT format digital audio tape, 2 channel",
    "DAT" => "DAT format digital audio tape, Stereo",
    "HDF" => "Removable Firewire (IEEE1394) hard disk drives",
    "HDS" => "Removable SCSI hard disk drives",
    "HDU" => "Removable USB2 hard disk drives",
    "JZD" => "JAZ format digital data disk",
    "MDA" => "MD (Mini-Disk) digital audio disk",
    "SSM4" => "USB Memory",
    "SSM5" => "Compact Flash",
    "SSM6" => "Memory Stick",
    "SSM7" => "SD Memory Card"}
  end
  
end
end
