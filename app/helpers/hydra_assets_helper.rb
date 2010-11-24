module HydraAssetsHelper

  # Render a link to delete the given asset from the repository.
  # Includes a confirmation message. 
  def delete_asset_link(pid, asset_type_display="asset")
    "<a href=\"\#delete_dialog\" id=\"delete_asset_link\" >Delete this #{asset_type_display}</a>"
  end

end
