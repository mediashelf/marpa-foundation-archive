module Marpa
class PbcoreInstantiation < ActiveFedora::NokogiriDatastream
  
  set_terminology do |t|
    t.root(:path=>"pbcoreInstantiationDocument", :xmlns=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html", "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance")    
    t.instantiation_identifier(:path=>"instantiationIdentifier")
    t.digital_format(:path=>"instantiationDigital")
    t.iana_format(:ref=>[:digital_format], :attributes=>{"source"=>"IANA MIME Media types"})
    t.file_size(:path=>"instantiationFileSize") {
      t.units(:path=>{:attribute=>"unitsOFMeasure"})
    }    
    t.file_size_mb(:ref=>[:file_size], :attributes=>{"unitsOFMeasure"=>"MB"})
    t.duration(:path=>"instantiationDuration")
    t.media_type(:path=>"instantiationMediaType")
    t.location(:path=>"instantiationLocation")
    t.note(:path=>"instantiationAnnotation")
    t.informal_note(:ref=>[:note], :attributes=>{"annotationType"=>"informal"})    
    t.technical_note(:ref=>[:note], :attributes=>{"annotationType"=>"technical"})
    t.workflow_status(:ref=>[:note], :attributes=>{"annotationType"=>"workflowStatus"})
  end
  
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.pbcoreInstantiationDocument("xmlns:xlink"=>"http://www.w3.org/1999/xlink",
         "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
         "xmlns"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html"," xsi:schemaLocation"=>"http://www.pbcore.org/PBCore/PBCoreNamespace.html") {
         xml.instantiationIdentifier
         xml.instantiationLocation
         xml.instantiationDigital(:source=>"IANA MIME Media types")
         xml.instantiationFileSize("unitsOfMeasure"=>"MB")
         xml.instantiationDuration
         xml.instantiationMediaType
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
