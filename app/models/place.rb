require 'marpa/datastreams/place'
class Place < ActiveFedora::Base
    def initialize (attrs = {} )
      attrs ||= {}
      super(attrs)
      update_properties(attrs)
    end

    def update_properties(properties)
      if (properties[:name])
        self.name=properties[:name]
      end
      if (properties[:map_coordinates])
        self.map_coordinates=properties[:map_coordinates]
      end
      if (properties[:description])
        self.description=properties[:description]
      end
    end
    has_metadata :name => "placeInfo", :type => Marpa::Datastreams::Place
    has_relationship "course", :is_location_of

    delegate :name, :to => :placeInfo
    delegate :description, :to => :placeInfo

    def map_coordinates
      "#{placeInfo.term_values(:latitude).first},#{placeInfo.term_values(:longitude).first}"
    end
    def map_coordinates=(val)
      lat,lon = val.split(',')
      placeInfo.update_indexed_attributes([:latitude] => lat)
      placeInfo.update_indexed_attributes([:longitude] => lon)
    end

   
end
