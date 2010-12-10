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
    checkUncheckProgress: function(id, bool) {  
        el = $("#"+id);
        if (bool) {
          el.addClass("progressItemChecked") 
         // el.show()
        } else {
          el.removeClass("progressItemChecked")          
        };
        // $fn.hydraProgressBox.testReleaseReadiness();
    },
    
    testReleaseReadiness: function() {
      console.log("check release readiness.")
      // if (citationVerified && abstractProvided && dissertationUploaded && rightsSelected && ccLicenseSelected && copyrightMaterialChecked) {
      //     $("submitToRegistrar").enable()
      // } else {
      //     $("submitToRegistrar").disable()
      // }
    }
  };
})( jQuery );