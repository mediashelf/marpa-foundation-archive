require 'marpa/datastreams/place'
class Place < ActiveFedora::Base
    extend ActiveModel::Naming
    include ActiveModel::Conversion
    def persisted?
      !self.new_object?
    end


    def initialize (attrs = {} )
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

    #TODO this is how we should do it in the future 
    #delegate :name, :to => :placeInfo
    def name
      placeInfo.term_values(:name).first
    end
    def name=(n)
      placeInfo.update_indexed_attributes([:name] => n)
    end

    def map_coordinates
      "#{placeInfo.term_values(:latitude).first},#{placeInfo.term_values(:longitude).first}"
    end
    def map_coordinates=(val)
      lat,lon = val.split(',')
      placeInfo.update_indexed_attributes([:latitude] => lat)
      placeInfo.update_indexed_attributes([:longitude] => lon)
    end

    def description
      placeInfo.term_values(:name).first
    end
    def description=(n)
      placeInfo.update_indexed_attributes([:description] => n)
    end

    private 

    def placeInfo
      datastreams['placeInfo'] 
    end
   
end
