module Marpa
  module Datastreams
    class EacCpf < ActiveFedora::NokogiriDatastream

      set_terminology do |t|
        t.root(:path=>"eac-cpf",
           :xmlns=>"urn:isbn:1-931666-33-4",
           "xmlns:mods"=>"http://www.loc.gov/mods/v3",
           "xmlns:xsi"=>"http://www.w3.org/2001/XMLSchema-instance",
           "xmlns:xlink"=>"http://www.w3.org/1999/xlink",
           "xsi:schemaLocation"=>"narm http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd",
           :schema=>"http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd")
         t.cpf_description(:path=>"cpfDescription", :index_as=>[:not_searchable]) {
           t.identity(:index_as=>[:not_searchable]) {
             t.entity_type(:path=>"entityType")
             t.name_entry(:path=>"nameEntry", :index_as=>[:not_searchable]) {
               t.display_(:path=>"part", :index_as=>[:not_searchable])
               t.authority(:path=>"authorizedForm", :index_as=>[:not_searchable])
             }
           }
         }
         t.control(:index_as=>[:not_searchable]) {
           t.freebase_id(:path=>"otherRecordId", :attributes=>{"localType"=>"freebase"}, :index_as=>[:not_searchable])
         }
         t.name_form(:ref=>[:cpf_description, :identity, :name_entry, :display], :index_as=>[:searchable])
         t.freebase_id(:ref=>[:control, :freebase_id], :index_as=>[:searchable, :displayable])
         # t.authorized_name_display
         # t.authorized_name_authority
         # t.unauthorized_name_display
      end
     
      def to_solr(solr_doc=Hash.new, field_mapper=nil)
         super
         narm_name = self.term_values("//oxns:nameEntry[oxns:authorizedForm='NARM']/oxns:part")
         solr_doc["title_t"] = narm_name
         solr_doc["title_display"] = narm_name
         solr_doc["narm_authorized_name_t"] = narm_name
         solr_doc["narm_authorized_name_display"] = narm_name
         supplier_name = self.term_values("//oxns:nameEntry[oxns:authorizedForm!='NARM']/oxns:part")
         solr_doc["supplier_authorized_name_t"] = supplier_name
         solr_doc["supplier_authorized_name_display"] = supplier_name
         aliases = self.term_values("//oxns:nameEntry[not(oxns:authorizedForm)]/oxns:part")
         solr_doc["nonauthorized_name_t"] = aliases
         solr_doc["nonauthorized_name_display"] = aliases
         return solr_doc
      end

    end    
  end
end
