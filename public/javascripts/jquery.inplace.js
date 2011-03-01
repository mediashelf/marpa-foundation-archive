//ON BLUR SAVE functionality original_element.children(“form”).children(“.inplace_field”).blur(function(){ //put the original background color in original_element.css(“background”, settings.bg_out);

var new_html = jQuery(this).parent().children(0).val();

//set saving message
if(settings.saving_image != ""){
    var saving_message = '<img src="' + settings.saving_image + '" alt="Saving..." />';
} else {
    var saving_message = settings.saving_text;
}

//place the saving text/image in the original element
original_element.html(saving_message);

if(settings.params != ""){
    settings.params = "&" + settings.params;
}

if(settings.callback) {
    html = settings.callback(original_element.attr("id"), new_html, original_html, settings.params);
    editing = false;
    click_count = 0;
    if (html) {
        // put the newly updated info into the original element
        original_element.html(html || new_html);
    } else {
        // failure; put original back
        alert("Failed to save value: " + new_html);
        original_element.html(original_html);
    }
} else if (settings.value_required && new_html == "") {
    editing = false;
    click_count = 0;
    original_element.html(original_html);
    alert("Error: You must enter a value to save this field");
} else {
    jQuery.ajax({
        url: settings.url,
        type: "POST",
        data: settings.update_value + '=' + new_html + '&' + settings.element_id + '=' + 
                original_element.attr("id") + settings.params + 
                '&' + settings.original_html + '=' + original_html,
        dataType: "html",
        complete: function(request){
            editing = false;
            click_count = 0;
        },
        success: function(html){
            // if the text returned by the server is empty, 
        // put a marker as text in the original element
            var new_text = html || settings.default_text;

            // put the newly updated info into the original element
            original_element.html(new_text);
            if (settings.success) settings.success(html, original_element);
        },
        error: function(request) {
            original_element.html(original_html);
            if (settings.error) settings.error(request, original_element);
        }
    });
}

return false;

});