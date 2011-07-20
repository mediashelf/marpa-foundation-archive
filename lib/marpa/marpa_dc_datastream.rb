module Marpa
class MarpaDCDatastream < ActiveFedora::NokogiriDatastream
  
  set_terminology do |t|
    t.root(:path=>"dc", :xmlns=>'http://purl.org/dc/terms/')
    t.tibetan_title(:path=>"title", :attributes=>{:language=>"tibetan"})
    t.english_title(:path=>"title", :attributes=>{:language=>:none})
    t.contributor(:index_as=>[:facetable])
    t.coverage
    t.creator
    t.description
    t.format
    t.identifier
    t.language(:index_as=>[:facetable])
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
    t.date(:index_as=>[:facetable])
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
    t.language(:index_as=>[:facetable])
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
    t.spatial(:index_as=>[:facetable])
    t.subject(:index_as=>[:facetable])
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