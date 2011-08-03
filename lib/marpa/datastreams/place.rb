module Marpa
  module Datastreams
    class Place < ActiveFedora::NokogiriDatastream
      set_terminology do |t|
        t.root(:path=>"location", :xmlns=>"http://yourmediashelf.com/schemas/marpaLocation/v0", 'xmlns:fb'=>'http://rdf.freebase.com/ns/', :index_as=>[:not_searchable])
        t.name
        t.description
        t.geolocation(:path=>'location.location.geolocation', :namespace_prefix=>'fb') {
          t.geocode(:path=>'location.geocode', :namespace_prefix=>'fb') {
            t.longitude(:path=>'location.geocode.longitude', :namespace_prefix=>'fb')
            t.latitude(:path=>'location.geocode.latitude', :namespace_prefix=>'fb')
          }
        }
        t.longitude(:proxy=>[:geolocation, :geocode, :longitude])
        t.latitude(:proxy=>[:geolocation, :geocode, :latitude])
      end

      def self.xml_template
        Nokogiri::XML::Document.parse '<location xmlns="http://yourmediashelf.com/schemas/marpaLocation/v0" xmlns:fb="http://rdf.freebase.com/ns/"> 
          <name></name>
          <description></description>
          <fb:location.location.geolocation>
            <fb:location.geocode>
              <fb:location.geocode.longitude></fb:location.geocode.longitude>
              <fb:location.geocode.latitude></fb:location.geocode.latitude>
            </fb:location.geocode>
          </fb:location.location.geolocation>
        </location>' 
      end
      
    end 
  end
end

