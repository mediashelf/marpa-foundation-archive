
module ApplicationHelper

  def render_facet_value(facet_solr_field, item, options ={})
    if item.is_a? Array
      link_to_unless(options[:suppress_link], item[0], add_facet_params_and_redirect(facet_solr_field, item[0]), :class=>"facet_select") + " (" + format_num(item[1]) + ")" 
    else
      link_to_unless(options[:suppress_link], item.value, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") + " (" + format_num(item.hits) + ")" 
    end
  end

  def render_complex_facet_value(facet_solr_field, item, options ={})    
    link_to_unless(options[:suppress_link], format_item_value(item.value), add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") + " (" + format_num(item.hits) + ")" 
  end

  def render_complex_facet_image(facet_solr_field, item, options = {})
    if File.exists?("#{Rails.root}/public/images/faculty_images/#{extract_computing_id(item.value)}.jpg")
      img = "<img src=\"/images/faculty_images/#{extract_computing_id(item.value)}.jpg\" width=\"100\" >"
    else
      img = "<img src=\"/images/default_thumbnail.gif\" width=\"90\" >"
    end

    link_to_unless(options[:suppress_link], img, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") 
  end

  def get_randomized_display_items items
    if items.length < 9 
      items.sort_by {|item| item.value }
    else 
      rdi = items.sort_by {rand}
      return rdi[0..7].sort_by {|item| item.value}
    end
    
  end

  def extract_computing_id val
    cid = val.split(" ")[-1]
    cid[1..cid.length-2]
  end

  def format_item_value val
    begin
      last, f_c = val.split(", ")
      first = f_c.split(" (")[0]
#first, last = val.split("##")[0..1]
    rescue
      return val.nil? ? "" : val
    end
    [last, "#{first[0..0]}."].join(", ")
  end
end
