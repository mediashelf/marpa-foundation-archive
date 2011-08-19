require 'spec_helper'

describe ProgramsController do
    it "should route to create" do
      { :post => programs_path() }.should route_to(:controller => 'programs', :action => 'create')
    end
    it "should route to edit" do
      { :get => edit_program_path('marpa:1') }.should route_to(:controller => 'programs', :action => 'edit', :id=>'marpa:1')
    end
    it "should route to update" do
      { :put => program_path('marpa:1') }.should route_to(:controller => 'programs', :action => 'update', :id=>'marpa:1')
    end

    it "should route to add_text_program" do
      { :post => add_program_text_program_path('marpa:1') }.should route_to(:controller => 'programs', :action => 'add_program_text', :id=>'marpa:1')
    end


end

