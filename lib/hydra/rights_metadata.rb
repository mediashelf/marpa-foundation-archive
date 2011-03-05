module Hydra
  require_dependency 'vendor/plugins/hydra_repository/lib/hydra/rights_metadata.rb'
  class RightsMetadata
    attr_reader :embargo_release_date
    def embargo_release_date=(release_date)
      release_date = release_date.to_s if release_date.is_a? Date
      begin
        Date.parse(release_date)
      rescue 
        return "INVALID DATE"
      end
      self.update_values({[:embargo,:machine,:date]=>release_date})
    end
    def embargo_release_date(opts={})
      embargo_release_date = self.find_by_terms(*[:embargo,:machine,:date]).first ? self.find_by_terms(*[:embargo,:machine,:date]).first.text : nil
      if opts[:format] && opts[:format] == :solr_date
        embargo_release_date << "T23:59:59Z"
      end
      embargo_release_date
    end
    def under_embargo?
      (embargo_release_date && Date.today < embargo_release_date.to_date) ? true : false
    end

    def to_solr(solr_doc=Hash.new)
      super(solr_doc)
      ::Solrizer::Extractor.insert_solr_field_value(solr_doc, "embargo_release_date_dt", embargo_release_date(:format=>:solr_date)) if embargo_release_date
      solr_doc
    end

  end
end
