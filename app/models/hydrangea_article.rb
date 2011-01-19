class HydrangeaArticle < ActiveFedora::Base
  require_dependency 'vendor/plugins/hydrangea_articles/app/models/hydrangea_article.rb'

  
  # Placeholder method that applies access rights if the object has been released and satisfies the requirements for release
  # The value of the "release_to" entry in the properties datastream is used to decide who should be granted access to the article.
  # If no release_to value has been set, defaults to "public"
  #
  # Requirements for release
  # * title is set
  # * an author is set
  # * at least one file has been uploaded
  #
  def apply_release(solr_doc)
    if ready_to_release?
      release_to = datastreams["properties"].release_to_values.first
      solr_doc << Solr::Field.new(:read_access_group_t => 'uva')
      if release_to == "public"
        solr_doc << Solr::Field.new(:read_access_group_t => release_to)
      end
    end
    solr_doc
  end
  


end
