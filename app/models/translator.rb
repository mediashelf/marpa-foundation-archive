require 'marpa/datastreams/eac_cpf'
class Translator < ActiveFedora::Base
  include Hydra::ModelMethods
  
  has_metadata :name => "eacCpf", :type => Marpa::Datastreams::EacCpf
  has_metadata :name => "rightsMetadata", :type => Hydra::RightsMetadata 
  
#    has_relationship "course", :is_translator_of

  delegate :tibetan_name, :to => :eacCpf, :unique=>true
end

