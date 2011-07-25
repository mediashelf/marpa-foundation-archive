require 'marpa/datastreams/eac_cpf'
class Author < ActiveFedora::Base
    has_metadata :name => "eacCpf", :type => Marpa::Datastreams::EacCpf
end
