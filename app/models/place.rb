require 'marpa/datastreams/location'
class Place < ActiveFedora::Base
    has_metadata :name => "placeInfo", :type => Marpa::Datastreams::Location
    has_relationship "course", :is_location_of
end
