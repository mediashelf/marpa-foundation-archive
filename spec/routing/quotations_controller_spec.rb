require 'spec_helper'

describe QuotationsController do
    it "should route to '/quotations/create'" do
      { :post => quotations_path() }.should route_to(:controller => 'quotations', :action => 'create')
    end

end
