(function($) {
  
  $.fn.hydraProgressBox = {    
    /*
    *  hydraProgressBox.checkUncheckProgress
    *  Change the checked/unchecked status of an item in the Progress Box
    *  @param 
    *
    * ie. 
    * hydraProgressBox.checkUncheckProgress($(true, 'pbCitationDetails');
    */
    checkUncheckProgress: function(elementId, bool) {  
        el = $("#"+elementId);
        if (bool) {
          el.addClass("progressItemChecked") 
          el.css("list-style-image",'url(/images/chkbox_checked.png)')
          // el.show();
        } else {
          el.removeClass("progressItemChecked")    
          el.css("list-style-image",'url(/images/chkbox_empty.png)')      
        };
        $.fn.hydraProgressBox.testReleaseReadiness();
    },
    
    showProcessingInProgress: function(elementId) {
      el = $("#"+elementId);
      el.css("list-style-image", 'url(/images/processing.gif)');
      // el.show();
    },
    
    testReleaseReadiness: function() {
      var fileUploaded = ($("#file_assets tr.file_asset").length > 0);
      var titleProvided = ($("#title_info_main_title").attr("value").length > 0);
      var authorProvided = ($("#person_0_last_name").attr("value").length > 0);
      var licenseAgreedTo = $("#copyright_uvalicense").is(':checked');

      if (fileUploaded && titleProvided && authorProvided && licenseAgreedTo) {
					$('ul#optional').css('background', 'white');
          $('ul#optional input').enable();
					$("#submitForRelease").enable();
      } else {
          $('ul#optional input').attr("disabled", "disabled");
          $('#submitForRelease').attr("disabled", "disabled");
      }
    }
  };
})( jQuery );