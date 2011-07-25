module Marpa
  module Datastreams
    class Place < ActiveFedora::NokogiriDatastream
      set_terminology do |t|
# <fb:location.location.geolocation><fb:location.geocode rdf:about="http://rdf.freebase.com/ns/m.0khstt"><fb:location.geocode.longitude rdf:datatype="http://www.w3.org/2001/XMLSchema#float">-122.333056</fb:location.geocode.longitude><fb:location.geocode.datum xml:lang="en">NAD83</fb:location.geocode.datum><fb:location.geocode.latitude rdf:datatype="http://www.w3.org/2001/XMLSchema#float">47.609722</fb:location.geocode.latitude></fb:location.geocode></fb:location.location.geolocation>
        t.root(:path=>"location", :xmlns=>"http://yourmediashelf.com/schemas/marpaLocation/v0", 'xmlns:fb'=>'http://rdf.freebase.com/ns/', :index_as=>[:not_searchable])
        t.name
        t.description
        t.geolocation(:path=>'location.location.geolocation', :xmlns=>'fb') {
          t.geocode(:path=>'location.geocode', :xmlns=>'fb') {
            t.longitude(:path=>'location.geocode.longitude', :xmlns=>'fb')
            t.latitude(:path=>'location.geocode.latitude', :xmlns=>'fb')
          }
        }
      end
      
    end 
  end
end

