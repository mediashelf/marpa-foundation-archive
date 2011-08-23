require 'marpa/datastreams/eac_cpf'
class Translator < ActiveFedora::Base
    has_metadata :name => "eacCpf", :type => Marpa::Datastreams::EacCpf
    has_relationship "course", :is_translator_of



    delegate :tibetan_name, :to => :eacCpf, :unique=>true
end

