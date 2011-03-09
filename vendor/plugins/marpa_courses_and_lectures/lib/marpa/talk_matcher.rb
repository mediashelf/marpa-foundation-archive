class Marpa::TalkMatcher
  
  def match
    orphans = find_objects_to_match
    orphans.each do |orphan|
      matches = find_matches_for(orphan)
      update_object_from_matches(orphan, matches)
    end
  end
  
  def update_object_from_matches(orphan, matches)
    if matches.empty?
      puts "!!! could not find matches for #{orphan["id"]}"
    else
      obj = load_fobject_from_hit(orphan)
      asserted = []
      matches.each do |hit|
        obj.add_relationship(:is_part_of, hit["id"])
        asserted << hit["id"]
      end
      obj.save
      puts "Updated #{obj.pid} to assert isPartOf #{asserted}"
    end
  end
  
  def find_objects_to_match(params={})
    search_params = {:rows => "1000", :q=>"active_fedora_model_s:S3Content"}.merge(params)
    solr_response = Blacklight.solr.find search_params
    docs = solr_response.docs
    # document_list = solr_response.docs.collect {|doc| SolrDocument.new(doc)}
    return docs
    # ActiveFedora::SolrService.instance.conn.query("active_fedora_model_s:S3Content").hits
  end
  
  # @param [Solr::Hit] solr hit or Solr document corresponding to the object you want to find matches for
  def find_matches_for(hit)
    if hit.has_key?("import_id_s")
      import_id = hit["import_id_s"].first
      matches = ActiveFedora::SolrService.instance.conn.query("digital_master_identifier_t:#{import_id}").hits
    else
      matches = []
    end
    return matches
  end
  
  def load_fobject_from_hit(hit)
    ActiveFedora::Base.load_instance(hit["id"])
  end
  
  def delete_corresponding_fobjects(hits)
    hits.each do |hit|
      obj = load_fobject_from_hit(hit)
      puts "deleting #{obj.pid}"
      obj.delete
    end
  end
  
end