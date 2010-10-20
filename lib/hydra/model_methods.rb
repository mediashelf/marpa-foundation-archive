module Hydra::ModelMethods
  require_dependency 'vendor/plugins/hydra_repository/lib/hydra/model_methods.rb'
  #
  # Adds metadata about the depositor to the asset 
  #
  def apply_depositor_metadata(depositor_id)
    prop_ds = self.datastreams_in_memory["properties"]
    rights_ds = self.datastreams_in_memory["rightsMetadata"]
  
    if !prop_ds.nil? && prop_ds.respond_to?(:depositor_values)
      prop_ds.depositor_values = depositor_id unless prop_ds.nil?
    end
    rights_ds.update_indexed_attributes([:edit_access, :person]=>depositor_id) unless rights_ds.nil?
    
    person = UVA::Person.new(depositor_id)
    desc_ds = self.datastreams_in_memory["descMetadata"]
    desc_ds.find_by_terms(:person, :first_name).first.content = person.first_name
    desc_ds.find_by_terms(:person, :last_name).first.content = person.last_name
    desc_ds.find_by_terms(:person, :institution).first.content = 'University of Virginia'
    
    return true
  end
end