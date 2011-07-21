module Marpa
  module Datastreams
    class AssociatedTexts < ActiveFedora::NokogiriDatastream
      set_terminology do |t|
        t.root(:path=>"associatedTexts", :xmlns=>"http://yourmediashelf.com/schemas/marpaTextAssociations/v0", :index_as=>[:not_searchable])
        t.associated_text(:path=>"associatedText", :index_as=>[:not_searchable]) do
          t.nature(:path=>{:attribute=>'nature'}, :index_as=>[:not_searchable])
          t.chapter(:index_as=>[:not_searchable])
          t.sections(:index_as=>[:not_searchable])
          t.pages(:index_as=>[:not_searchable])
          t.text(:path=>'identifier', :attributes=>{:authority=>'local'}, :index_as=>[:not_searchable])  # a pid pointing at a Text
        end
      end
    end
  end
end
