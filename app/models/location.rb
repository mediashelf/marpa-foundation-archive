require 'marpa/datastreams/location'
class Location < ActiveFedora::Base
    has_metadata :name => "location", :type => Marpa::Datastreams::Location
    has_relationship "course", :is_location_of
end
