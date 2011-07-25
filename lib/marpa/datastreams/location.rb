module Marpa
  module Datastreams
    class Location < ActiveFedora::NokogiriDatastream
      set_terminology do |t|
        t.root(:path=>"location", :xmlns=>"http://yourmediashelf.com/schemas/marpaLocation/v0", :index_as=>[:not_searchable])
        t.name
        t.latitude(:index_as=>[:not_searchable])
        t.longitude(:index_as=>[:not_searchable])
        t.description
      end
      
    end 
  end
end

