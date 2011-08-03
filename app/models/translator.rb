require 'marpa/datastreams/eac_cpf'
class Translator < ActiveFedora::Base
    has_metadata :name => "eacCpf", :type => Marpa::Datastreams::EacCpf
    has_relationship "course", :is_translator_of


    def initialize (attrs = {} )
      super(attrs)
      update_properties(attrs)
    end

    def update_properties(properties)
      if (properties[:tibetan_name])
        self.tibetan_name=properties[:tibetan_name]
      end
    end

    delegate :tibetan_name, :to => :eacCpf
end

