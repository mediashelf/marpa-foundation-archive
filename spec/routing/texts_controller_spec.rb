require 'spec_helper'

describe TextsController do
    it "should route to '/texts/create'" do
      { :post => texts_path() }.should route_to(:controller => 'texts', :action => 'create')
    end

end
