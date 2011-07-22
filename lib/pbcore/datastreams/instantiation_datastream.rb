module PBCore
  module Datastreams
    class InstantiationDatastream < ActiveFedora::NokogiriDatastream
      @terminology = PBCore::Terminologies::DescriptionDocument
    end
  end
end