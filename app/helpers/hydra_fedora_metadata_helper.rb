
module HydraFedoraMetadataHelper
  require_dependency 'vendor/plugins/hydra_repository/app/helpers/hydra_fedora_metadata_helper.rb'

  def fedora_text_field(resource, datastream_name, field_key, opts={})
    field_name = field_name_for(field_key)
    field_values = get_values_from_datastream(resource, datastream_name, field_key, opts)
    field_values = [""] if field_values.empty?
    if opts.fetch(:multiple, true)
      container_tag_type = :li
    else
      field_values = [field_values.first]
      container_tag_type = :span
    end
    
    body = ""
    
    field_values.each_with_index do |current_value, z|
      base_id = generate_base_id(field_name, current_value, field_values, opts)
      name = "asset[#{datastream_name}][#{field_name}][#{z}]"
      body << "<#{container_tag_type.to_s} class=\"editable-container field\" id=\"#{base_id}-container\">"
        body << "<a href=\"\" title=\"Delete '#{h(current_value)}'\" class=\"destructive field\">Delete</a>" if opts.fetch(:multiple, true) && !current_value.empty?
        body << "<span class=\"editable-text text\" id=\"#{base_id}-text\" style=\"display:none;\">#{h(current_value.lstrip)}</span>"
        body << "<input class=\"editable-edit edit\" id=\"#{base_id}\" data-datastream-name=\"#{datastream_name}\" rel=\"#{field_name}\" name=\"#{name}\" value=\"#{h(current_value.lstrip)}\"/>"
      body << "</#{container_tag_type}>"
    end
    result = field_selectors_for(datastream_name, field_key)
    if opts.fetch(:multiple, true)
      result << content_tag(:ol, body, :rel=>field_name)
    else
      result << body
    end
    
    return result
  end
  def fedora_text_area(resource, datastream_name, field_key, opts={})
    fedora_textile_text_area(resource, datastream_name, field_key, opts)
  end
  
  # Textile textarea varies from the other methods in a few ways
  # Since we're using jeditable with this instead of fluid, we need to provide slightly different hooks for the javascript
  # * we are storing the datastream name in data-datastream-name so that we can construct a load url on the fly when initializing the textarea
  def fedora_textile_text_area(resource, datastream_name, field_key, opts={})
    field_name = field_name_for(field_key)
    field_values = get_values_from_datastream(resource, datastream_name, field_key, opts)
    field_values = [""] if field_values.empty?
    if opts.fetch(:multiple, true)
      container_tag_type = :li
    else
      field_values = [field_values.first]
      container_tag_type = :span
    end
    body = ""
    
    field_values.each_with_index do |current_value, z|
      base_id = generate_base_id(field_name, current_value, field_values, opts)
      name = "asset[#{datastream_name}][#{field_name}][#{z}]"
      processed_field_value = white_list( RedCloth.new(current_value, [:sanitize_html]).to_html)
      
      body << "<#{container_tag_type.to_s} class=\"editable-container field\" id=\"#{base_id}-container\">"
        # Not sure why there is we're not allowing the for the first textile to be deleted, but this was in the original helper.
        body << "<a href=\"\" title=\"Delete '#{h(current_value)}'\" class=\"destructive field\">Delete</a>" unless z == 0
        body << "<span class=\"editable-text text\" id=\"#{base_id}-text\" style=\"display:none;\">#{processed_field_value}</span>"
        body << "<textarea class=\"editable-edit edit\" id=\"#{base_id}\" data-datastream-name=\"#{datastream_name}\" rel=\"#{field_name}\" name=\"#{name}\">#{h(current_value)}</textarea>"
        #body << "<input class=\"editable-edit edit\" id=\"#{base_id}\" data-datastream-name=\"#{datastream_name}\" rel=\"#{field_name}\" name=\"#{name}\" value=\"#{h(current_value)}\"/>"
      body << "</#{container_tag_type}>"
    end
    
    result = field_selectors_for(datastream_name, field_key)
    
    if opts.fetch(:multiple, true)
      result << content_tag(:ol, body, :rel=>field_name)
    else
      result << body
    end
    return result
    
  end
  
  def fedora_checkbox(resource, datastream_name, field_key, opts={})
    result = ""
    field_values = get_values_from_datastream(resource, datastream_name, field_key, opts)
    h_name = OM::XML::Terminology.term_hierarchical_name(*field_key)    
    
    v_name = field_key.last.to_s

    checked = field_values.first.downcase == "yes" ? "checked" : ""
    
    result = field_selectors_for(datastream_name, field_key)
    
    if field_values.first.downcase == "yes"
      result << tag(:input, :type=>"checkbox", :id=>h_name, :class=>"fedora-checkbox", :rel=>h_name, :name=>"asset[#{datastream_name}][#{h_name}][0]", :value=>"yes", :checked=>"checked")
    else
      result << tag(:input, :type=>"checkbox", :id=>h_name, :class=>"fedora-checkbox", :rel=>h_name, :name=>"asset[#{datastream_name}][#{h_name}][0]", :value=>"no")
    end
    return result
  end
  
  # Expects :choices option. 
  # :choices should be a hash with value/label pairs
  # :choices => {"first_choice"=>"Apple", "second_choice"=>"Pear" }
  # If no :choices option is provided, returns a regular fedora_text_field
  def fedora_radio_button(resource, datastream_name, field_key, opts={})
    if opts[:choices].nil?
      result = fedora_text_field(resource, datastream_name, field_key, opts)
    else
      choices = opts[:choices]
      
      field_name = field_name_for(field_key)
      field_values = get_values_from_datastream(resource, datastream_name, field_key, opts)
      h_name = OM::XML::Terminology.term_hierarchical_name(*field_key)    
      default_value = opts.keys.include?(:default_value) ? opts[:default_value] : ""
      
      selected_value = field_values.empty? ? "" : field_values.first
      selected_value = default_value if selected_value.blank?

      body = ""
      z = 0
      base_id = generate_base_id(field_name, field_values.first, field_values, opts.merge({:multiple=>false}))
      name = "asset[#{datastream_name}][#{field_name}][#{z}]"
      
      result = field_selectors_for(datastream_name, field_key)
      choices.sort.each do |choice,label|
        if choice == selected_value
          result << tag(:input, :type=>"radio", :id=>"availability_#{choice}", :class=>"fedora-radio-button", :rel=>h_name, :name=>"asset[#{datastream_name}][#{h_name}][0]", :value=>choice.downcase, :checked=>true)
        else
          result << tag(:input, :type=>"radio", :id=>"availability_#{choice}", :class=>"fedora-radio-button", :rel=>h_name, :name=>"asset[#{datastream_name}][#{h_name}][0]", :value=>choice.downcase)
        end
        result << " <label>#{label}</label> "
      end
      result
    end
    return result
  end
   # retrieve field values from datastream.
  # If :values is provided, skips accessing the datastream and returns the contents of :values instead.
#  def get_values_from_datastream(resource, datastream_name, field_key, opts={})
#    if opts.has_key?(:values)
#      values = opts[:values]
#      if values.nil? then values = [opts.fetch(:default, "")] end
#    else
#      values = resource.get_values_from_datastream(datastream_name, field_key, opts.fetch(:default, ""))
#      raise "TEXTAREA_FIELDVALUES: GVFD: #{values}"
#      if values.empty? then values = [ opts.fetch(:default, "") ] end
#    end
#    
#    return values
#  end
  
end
