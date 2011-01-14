module Hydra
  require_dependency 'vendor/plugins/hydra_repository/lib/hydra/mods_article.rb'
  
  class ModsArticle < ActiveFedora::NokogiriDatastream       
    
    include Uva::ModsIndexMethods

    set_terminology do |t|
      t.root(:path=>"mods", :xmlns=>"http://www.loc.gov/mods/v3", :schema=>"http://www.loc.gov/standards/mods/v3/mods-3-2.xsd")

      t.title_info(:path=>"titleInfo") {
        t.main_title(:index_as=>[:facetable],:path=>"title", :label=>"title")
        t.language(:index_as=>[:facetable],:path=>{:attribute=>"lang"})
      } 
      t.language{
        t.lang_code(:index_as=>[:facetable], :path=>"languageTerm", :attributes=>{:type=>"code"})
      }
      t.abstract   
      t.subject {
        t.topic(:index_as=>[:facetable])
      }      
      t.topic_tag(:proxy=>[:subject, :topic])    
      # t.topic_tag(:index_as=>[:facetable],:path=>"subject", :default_content_path=>"topic")
      # This is a mods:name.  The underscore is purely to avoid namespace conflicts.
      t.name_ {
        # this is a namepart
        t.namePart(:type=>:string, :label=>"generic name")
        # affiliations are great
        t.affiliation
        t.institution(:path=>"affiliation", :index_as=>[:facetable], :label=>"organization")
        t.displayForm
        t.role(:ref=>[:role])
        t.description
        t.date(:path=>"namePart", :attributes=>{:type=>"date"})
        t.last_name(:path=>"namePart", :attributes=>{:type=>"family"})
        t.first_name(:path=>"namePart", :attributes=>{:type=>"given"}, :label=>"first name")
        t.terms_of_address(:path=>"namePart", :attributes=>{:type=>"termsOfAddress"})
        t.computing_id
      }
      # lookup :person, :first_name        
      t.person(:ref=>:name, :attributes=>{:type=>"personal"}, :index_as=>[:facetable])
      t.organization(:ref=>:name, :attributes=>{:type=>"corporate"}, :index_as=>[:facetable])
      t.conference(:ref=>:name, :attributes=>{:type=>"conference"}, :index_as=>[:facetable])
      t.role {
        t.text(:path=>"roleTerm",:attributes=>{:type=>"text"})
        t.code(:path=>"roleTerm",:attributes=>{:type=>"code"})
      }
      t.journal(:path=>'relatedItem', :attributes=>{:type=>"host"}) {
        t.title_info(:index_as=>[:facetable],:ref=>[:title_info])
        t.origin_info(:path=>"originInfo") {
          t.publisher
          t.date_issued(:path=>"dateIssued")
        }
        t.issn(:path=>"identifier", :attributes=>{:type=>"issn"})
        t.issue(:path=>"part") {
          t.volume(:path=>"detail", :attributes=>{:type=>"volume"}, :default_content_path=>"number")
          t.level(:path=>"detail", :attributes=>{:type=>"number"}, :default_content_path=>"number")
          t.extent
          t.pages(:path=>"extent", :attributes=>{:unit=>"pages"}) {
            t.start
            t.end
          }
          t.start_page(:proxy=>[:pages, :start])
          t.end_page(:proxy=>[:pages, :end])
          t.publication_date(:path=>"date")
        }
      }
      t.note
      t.location(:path=>"location") {
        t.url (:path=>"url")
      }
      t.publication_url(:proxy=>[:location,:url])
    end
    
    # Generates an empty Mods Article (used when you call ModsArticle.new without passing in existing xml)
    def self.xml_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.mods(:version=>"3.3", "xmlns:xlink"=>"http://www.w3.org/1999/xlink",
           "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
           "xmlns"=>"http://www.loc.gov/mods/v3",
           "xsi:schemaLocation"=>"http://www.loc.gov/mods/v3 http://www.loc.gov/standards/mods/v3/mods-3-3.xsd") {
             xml.titleInfo(:lang=>"") {
               xml.title
             }
             xml.name(:type=>"personal") {
               xml.namePart(:type=>"given")
               xml.namePart(:type=>"family")
               xml.affiliation
               xml.computing_id
               xml.description
               xml.role {
                 xml.roleTerm("Author", :authority=>"marcrelator", :type=>"text")
               }
             }
             xml.typeOfResource
             xml.genre(:authority=>"marcgt")
             xml.language {
               xml.languageTerm(:authority=>"iso639-2b", :type=>"code")
             }
             xml.abstract
             xml.subject {
               xml.topic
             }
             xml.relatedItem(:type=>"host") {
               xml.titleInfo {
                 xml.title
               }
               xml.identifier(:type=>"issn")
               xml.originInfo {
                 xml.publisher
                 xml.dateIssued
               }
               xml.part {
                 xml.detail(:type=>"volume") {
                   xml.number
                 }
                 xml.detail(:type=>"number") {
                   xml.number
                 }
                 xml.extent(:unit=>"pages") {
                   xml.start
                   xml.end
                 }
                 xml.date
               }
             }
             xml.location {
               xml.url
             }
        }
      end
      return builder.doc
    end
    
    # Generates a new Person node
    def self.person_template
      builder = Nokogiri::XML::Builder.new do |xml|
        xml.name(:type=>"personal") {
          xml.namePart(:type=>"family")
          xml.namePart(:type=>"given")
          xml.affiliation
          xml.computing_id
          xml.role {
            xml.roleTerm("Author", :type=>"text")
          }
        }
      end
      return builder.doc.root
    end
    
    def to_solr(solr_doc=Solr::Document.new)
      super(solr_doc)
      extract_person_full_names.each {|pfn| solr_doc << pfn }
      extract_person_organizations.each {|org| solr_doc << org }
      extract_person_full_names_and_computing_ids.each {|pfc| solr_doc << pfc }
      solr_doc << {:object_type_facet => "Article"}
      solr_doc << {:mods_journal_title_info_facet => "Unknown" } if solr_doc["mods_journal_title_info_facet"].nil? || solr_doc["mods_journal_title_info_facet"].blank?
      solr_doc
    end
  end
end
