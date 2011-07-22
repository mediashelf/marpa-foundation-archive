module PBCore::ModelMixins
  module InstantiationAsset
    def self.included(klazz)
      klazz.has_metadata :name => "pbCore", :type => PBCore::Datastreams::InstantiationDatastream
      
      # Ensure that objects assert the pbCoreInstantiation cModel
      # klazz.relationships << :has_model => "info:fedora/pbcore:AssetInstantiation"
    end
  end
end