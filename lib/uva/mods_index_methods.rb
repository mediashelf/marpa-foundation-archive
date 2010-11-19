module Uva::ModsIndexMethods
  # extracts the last_name##full_name##computing_id to be used by home view
  def extract_person_full_names_and_computing_ids
    self.find_by_terms(:person).inject([]) do |names, person|
      name_parts = person.children.inject({}) do |hash,child|
        hash[child.get_attribute(:type)] = child.text if ["family","given"].include? child.get_attribute(:type)
        hash["computing_id"] = child.text if child.name == 'computing_id'
        hash
      end
      if name_parts.length == 3
        value = "#{name_parts["family"]}, #{name_parts["given"]} (#{name_parts["computing_id"]})"
        names << Solr::Field.new({"person_full_name_cid_facet".to_sym=>value}) if name_parts.length == 3
      end
      names
    end
  end

end
