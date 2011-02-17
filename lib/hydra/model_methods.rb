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
    
    apply_ldap_values(depositor_id, 0)
    
    return true
  end
  
  #
  # looks through the params to fetch the computing id, then dispatches to ldap lookup to update
  #
  def update_from_computing_id(params)
    params["asset"].each_pair do |datastream_name,fields|
      if params.fetch("field_selectors",false) && params["field_selectors"].fetch(datastream_name, false)
        fields.each_pair do |field_name,field_values|
          if field_name =~ /computing_id/
            person_number = field_name[/_\d+_/].tr("_", "").to_i
            computing_id = field_values["0"]
            apply_ldap_values(computing_id, person_number)
          end
        end
      end
    end
  end
  
  #
  # applies the ldap attributes
  #
  def apply_ldap_values(computing_id, person_number)
    person = Ldap::Person.new(computing_id)
    desc_ds = self.datastreams_in_memory["descMetadata"]
    return if desc_ds.nil?
    desc_ds.find_by_terms(:person, :computing_id)[person_number].content = person.computing_id
    desc_ds.find_by_terms(:person, :first_name)[person_number].content = person.first_name
    desc_ds.find_by_terms(:person, :last_name)[person_number].content = person.last_name
    desc_ds.find_by_terms(:person, :institution)[person_number].content = person.institution    
    desc_ds.find_by_terms(:person, :description)[person_number].content = person.department
  end
  
end
