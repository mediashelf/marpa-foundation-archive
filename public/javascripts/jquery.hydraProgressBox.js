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
          el.css("background-image",'url(/images/chkbox_checked.png)')
          // el.show();
        } else {
          el.removeClass("progressItemChecked")    
          el.css("background-image",'url(/images/chkbox_empty.png)')      
        };
        $.fn.hydraProgressBox.testReleaseReadiness();
    },
    
    showProcessingInProgress: function(elementId) {
      el = $("#"+elementId);
      el.css("background-image", 'url(/images/processing.gif)');
      // el.show();
    },
    
    testReleaseReadiness: function() {
      var fileUploaded = ($("#file_assets tr.file_asset").length > 0);
      var titleProvided = ($("#title_info_main_title").attr("value").length > 0);
      var authorProvided = ($("#person_0_last_name").attr("value").length > 0);

      if (fileUploaded && titleProvided && authorProvided) {
          $("#submitForRelease").enable();
      } else {
          $("#submitForRelease").attr("disabled", "disabled");
      }
    }
  };
})( jQuery );