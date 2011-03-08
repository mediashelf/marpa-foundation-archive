module Marpa
class MarpaDCDatastream < ActiveFedora::NokogiriDatastream
  
  set_terminology do |t|
    t.root(:path=>"dc", :xmlns=>'http://purl.org/dc/terms/')
    t.tibetan_title(:path=>"title", :attributes=>{:language=>"tibetan"})
    t.english_title(:path=>"title", :attributes=>{:language=>:none})
    t.contributor
    t.coverage
    t.creator
    t.description
    t.format
    t.identifier
    t.language
    t.publisher
    t.relation
    t.source
    t.title
    t.abstract
    t.accessRights
    t.accrualMethod
    t.accrualPeriodicity
    t.accrualPolicy
    t.alternative
    t.audience
    t.available
    t.bibliographicCitation
    t.conformsTo
    t.contributor
    t.coverage
    t.created
    t.creator
    t.date
    t.dateAccepted
    t.dateCopyrighted
    t.dateSubmitted
    t.description
    t.educationLevel
    t.extent
    t.format
    t.hasFormat
    t.hasPart
    t.hasVersion
    t.identifier
    t.instructionalMethod
    t.isFormatOf
    t.isPartOf
    t.isReferencedBy
    t.isReplacedBy
    t.isRequiredBy
    t.issued
    t.isVersionOf
    t.language
    t.license
    t.mediator
    t.medium
    t.modified
    t.provenance
    t.publisher
    t.references
    t.relation
    t.replaces
    t.requires
    t.rights
    t.rightsHolder
    t.source
    t.spatial
    t.subject
    t.tableOfContents
    t.temporal
    t.type
    t.valid
  end
  
  def self.xml_template
    builder = Nokogiri::XML::Builder.new do |xml|
      xml.dc("xmlns"=>'http://purl.org/dc/terms/',
        "xmlns:dcterms"=>'http://purl.org/dc/terms/', 
        "xmlns:xsi"=>'http://www.w3.org/2001/XMLSchema-instance') {
      }
    end
    return builder.doc
  end
  
end
end