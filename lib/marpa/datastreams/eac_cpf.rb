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
           :schema=>"http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd", :index_as=>[:not_searchable])
         t.cpf_description(:path=>"cpfDescription", :index_as=>[:not_searchable]) {
           t.identity(:index_as=>[:not_searchable]) {
             t.entity_type(:path=>"entityType", :index_as=>[:not_searchable])
             t.parallel_names(:path=>"nameEntryParallel", :index_as=>[:not_searchable]) { 
               t.tibetan_name(:path=>"nameEntry", :attributes=>{'xml:lang'=>'tib', 'scriptCode'=>'Tibt'}, :index_as=>[:not_searchable]) {
                 t.display_(:path=>"part") #, :index_as=>[:not_searchable])
               }
               t.wylie_name(:path=>"nameEntry", :attributes=>{'xml:lang'=>'tib', 'scriptCode'=>'Latn', 'transliteration'=>'wylie'}, :index_as=>[:not_searchable]) {
                 t.display_(:path=>"part")#, :index_as=>[:not_searchable])
               }
               t.phonetic_name(:path=>"nameEntry", :attributes=>{'xml:lang'=>'skt', 'scriptCode'=>'Latn', 'transliteration'=>'marpa'}, :index_as=>[:not_searchable]) {
                 t.display_(:path=>"part")#, :index_as=>[:not_searchable])
               }
             } 
           }
         }
         t.control(:index_as=>[:not_searchable]) {
           t.tbrc_id(:path=>"otherRecordId", :attributes=>{"localType"=>"tbrc"}, :index_as=>[:not_searchable])
         }
         t.tbrc_id(:ref=>[:control, :tbrc_id], :index_as=>[:searchable])
 
         t.tibetan_name(:proxy=>[:cpf_description, :identity, :parallel_names, :tibetan_name, :display])
         t.wylie_name(:proxy=>[:cpf_description, :identity, :parallel_names, :wylie_name, :display])
         t.phonetic_name(:proxy=>[:cpf_description, :identity, :parallel_names, :phonetic_name, :display], :index_as=>[:searchable])
      end
     
      def to_solr(solr_doc=Hash.new, field_mapper=nil)
         super
         return solr_doc
      end

      def self.xml_template
        Nokogiri::XML::Document.parse '<eac-cpf xmlns="urn:isbn:1-931666-33-4" xmlns:xlink="http://www.w3.org/1999/xlink" xmlns:xsi="http://www.w3.org/2001/XMLSchema-instance" xsi:schemaLocation="urn:isbn:1-931666-33-4 http://eac.staatsbibliothek-berlin.de/schema/cpf.xsd"> 
          <control></control>
        </eac-cpf>' 
      end

    end    
  end
end
