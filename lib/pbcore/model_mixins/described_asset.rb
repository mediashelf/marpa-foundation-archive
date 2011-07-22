module PBCore::ModelMixins
  module DescribedAsset
    def self.included(klazz)
      klazz.has_metadata :name => "pbCore", :type => PBCore::Datastreams::DescriptionDocument
            
      # Ensure that objects assert the pbCoreInstantiation cModel
      # klazz.relationships << :has_model => "info:fedora/pbcore:DescribedAsset"
    end
  end
end