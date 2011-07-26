require 'marpa/datastreams/place'
class Place < ActiveFedora::Base
    has_metadata :name => "placeInfo", :type => Marpa::Datastreams::Place
    has_relationship "course", :is_location_of
end
