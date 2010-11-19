
module ApplicationHelper


  def render_complex_facet_value(facet_solr_field, item, options ={})    
    link_to_unless(options[:suppress_link], format_item_value(item.value), add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") + " (" + format_num(item.hits) + ")" 
  end

  def render_complex_facet_image(facet_solr_field, item, options = {})
    if File.exists?("#{Rails.root}/public/images/faculty_images/#{extract_computing_id(item.value)}.jpg")
      "<img src=\"/images/faculty_images/#{extract_computing_id(item.value)}.jpg\" width=\"100\" >"
    else
      "<img src=\"/images/default_thumbnail.gif\" width=\"90\" >"
    end
  end

  def get_randomized_display_items items
    if items.length < 9 
      items
    else 
      rdi = items.sort_by {rand}
      return rdi[0..7].sort_by {|item| item.value}
    end
    
  end

  def extract_computing_id val
    val.split("##")[-1]
  end

  def format_item_value val
    first, last = val.split("##")[0..1]
    [first, "#{last[0..0]}."].join(", ")
  end
end
