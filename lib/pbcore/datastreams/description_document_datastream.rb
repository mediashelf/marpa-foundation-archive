module PBCore
  module Datastreams
    class DescriptionDocument < ActiveFedora::NokogiriDatastream
      @terminology = PBCore::Terminologies::InstantiationDocument
    end
  end
end