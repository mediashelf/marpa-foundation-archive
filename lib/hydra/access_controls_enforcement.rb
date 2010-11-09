module Hydra::AccessControlsEnforcement
  require_dependency 'vendor/plugins/hydra_repository/lib/hydra/access_controls_enforcement.rb'
  
  private
  
  def build_lucene_query(user_query)
    q = ""
    # start query of with user supplied query term
      q << "_query_:\"{!dismax qf=$qf_dismax pf=$pf_dismax}#{user_query}\""

    # Append the exclusion of FileAssets
      q << " AND NOT _query_:\"info\\\\:fedora/afmodel\\\\:FileAsset\""

    # Append the query responsible for adding the users discovery level
      permission_types = ["edit","discover","read"]
      field_queries = []
      permission_types.each do |type|
        field_queries << "_query_:\"#{type}_access_group_t:public\""
      end

      unless current_user.nil?
        # for roles
        RoleMapper.roles(current_user.login).each do |role|
          permission_types.each do |type|
            field_queries << "_query_:\"#{type}_access_group_t:#{role}\""
          end
        end
        # for individual person access
        permission_types.each do |type|
          field_queries << "_query_:\"#{type}_access_person_t:#{current_user.login}\""
        end
        if current_user.is_being_superuser?(session)
          permission_types.each do |type|
            field_queries << "_query_:\"#{type}_access_person_t:[* TO *]\""
          end
        end
      end
      q << " AND (#{field_queries.join(" OR ")})"
    return q
  end

end