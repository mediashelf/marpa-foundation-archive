class AssetsController < ApplicationController
  #helper :libra
  include LibraHelper
  
  # Uses the update_indexed_attributes method provided by ActiveFedora::Base
  # This should behave pretty much like the ActiveRecord update_indexed_attributes method
  # For more information, see the ActiveFedora docs.
  # 
  # Examples
  # put :update, :id=>"_PID_", "document"=>{"subject"=>{"-1"=>"My Topic"}}
  # Appends a new "subject" value of "My Topic" to any appropriate datasreams in the _PID_ document.
  # put :update, :id=>"_PID_", "document"=>{"medium"=>{"1"=>"Paper Document", "2"=>"Image"}}
  # Sets the 1st and 2nd "medium" values on any appropriate datasreams in the _PID_ document, overwriting any existing values.
  def update
    af_model = retrieve_af_model(params[:content_type])
    unless af_model 
      af_model = HydrangeaArticle
    end
    @document = af_model.find(params[:id])
          
    updater_method_args = prep_updater_method_args(params)

    @document.update_from_computing_id(params)
  
    logger.debug("attributes submitted: #{updater_method_args.inspect}")
    # this will only work if there is only one datastream being updated.
    # once ActiveFedora::MetadataDatastream supports .update_datastream_attributes, use that method instead (will also be able to pass through params["asset"] as-is without usin prep_updater_method_args!)
    result = @document.update_indexed_attributes(updater_method_args[:params], updater_method_args[:opts])
    @document.save
    #response = attrs.keys.map{|x| escape_keys({x=>attrs[x].values})}
    response = Hash["updated"=>[]]
    last_result_value = ""
    result.each_pair do |field_name,changed_values|
      changed_values.each_pair do |index,value|
        response["updated"] << {"field_name"=>field_name,"index"=>index,"value"=>value} 
        last_result_value = value
      end
    end
    logger.debug("returning #{response.inspect}")
  
    # If handling submission from jeditable (which will only submit one value at a time), return the value it submitted
    if params.has_key?(:field_id)
      response = last_result_value
    end
  
    respond_to do |want| 
      want.html { 
        if @document.class == HydrangeaArticle
          display_release_status_notice(@document)
        end
        redirect_to(edit_catalog_url) 
      }
      want.js   { render :json=> response }
      want.textile {
        if response.kind_of?(Hash)
          response = response.values.first
        end
        render :text=> white_list( RedCloth.new(response, [:sanitize_html]).to_html )
      }
    end
  end
end