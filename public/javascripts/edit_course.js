(function($){

  /* options
      server: the mile marker server to talk to
      mmToken: the mile marker token 
      afterListUpdate: callback to execute after list updates.
  */

  function editCourse(options, $element) {
  
    var settings = {
      contextPath: "/franchise"
    };

    /* PRIVATE VARIABLES */

    
     
    /* PRIVATE METHODS */
    
    // constructor 
    function init() {
      if ( options ) { 
        $.extend( settings, options );
      }
      editableFields();
    }
  
    function editableFields() {
      var title = $('#title', $element).hide();
      var titleText = $('#title-text', $element).show();
      $('#edit-title', $element).click(function () {
        title.show();
        titleText.hide();
        return false;
      });

    }

    // run constructor
    init();
    
    /* PUBLIC METHODS */
    
    return {
      // public methods go here
    };
  }
  
  // jQuery plugin method
  $.fn.editCourse = function(options) {
    return this.each(function() {
      var $this = $(this);
     
      // Store plugin object in this element's data if it doesn't already exist 
      if (!$this.data('editCourse')) {
        $this.data('editCourse', editCourse(options, $this));
      }
    });
  };
})(jQuery);



