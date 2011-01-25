
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
  
  def render_journal_facet_value(facet_solr_field, item, options ={})
    
    val = item.value.strip.length > 12 ? item.value.strip[0..12].concat("...") : item.value.strip
    link_to_unless(options[:suppress_link], val, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") + " (" + format_num(item.hits) + ")" 
  end

  def render_complex_facet_image(facet_solr_field, item, options = {})
    if File.exists?("#{Rails.root}/public/images/faculty_images/#{extract_computing_id(item.value)}.jpg")
      img = "<img src=\"/images/faculty_images/#{extract_computing_id(item.value)}.jpg\" width=\"100\" >"
    else
      img = "<img src=\"/images/default_thumbnail.gif\" width=\"90\" >"
    end

    link_to_unless(options[:suppress_link], img, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") 
  end

  def render_journal_image(facet_solr_field, item, options = {})
    if File.exists?("#{Rails.root}/public/images/journal_images/#{item.value.strip.downcase.gsub(/\s+/,'_')}.jpg")
      img = "<img src=\"/images/journal_images/#{item.value.strip.downcase.gsub(/\s+/,'_')}.jpg\" width=\"100\" >"
    else
      img = "<img src=\"/images/default_thumbnail.gif\" width=\"90\" >"
    end

    link_to_unless(options[:suppress_link], img, add_facet_params_and_redirect(facet_solr_field, item.value), :class=>"facet_select") 
  end

  def get_randomized_display_items items
#items = disp_items.map {|m| m unless m.nil? || m.value.strip.blank? }
    clean_items = items.each.inject([]) do |array, item|
      array << item unless item.value.strip.blank?
      array
    end

    if clean_items.length < 9 
      clean_items.sort_by {|item| item.value }
    else 
      rdi = clean_items.sort_by {rand}
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

#   COPIED from vendor/plugins/blacklight/app/helpers/application_helper.rb
  # Used in catalog/facet action, facets.rb view, for a click
  # on a facet value. Add on the facet params to existing
  # search constraints. Remove any paginator-specific request
  # params, or other request params that should be removed
  # for a 'fresh' display. 
  # Change the action to 'index' to send them back to
  # catalog/index with their new facet choice. 
  def add_facet_params_and_redirect(field, value)
    new_params = add_facet_params(field, value)

    # Delete page, if needed. 
    new_params.delete(:page)

    # Delete :qt, if needed - added to resolve NPE errors
    new_params.delete(:qt)

    # Delete any request params from facet-specific action, needed
    # to redir to index action properly. 
    Blacklight::Solr::FacetPaginator.request_keys.values.each do |paginator_key| 
      new_params.delete(paginator_key)
    end
    new_params.delete(:id)

    # Force action to be index. 
    new_params[:action] = "index"

    new_params
  end



end
