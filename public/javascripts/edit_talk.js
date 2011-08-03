(function($){

  /* options
      server: the mile marker server to talk to
      mmToken: the mile marker token 
      afterListUpdate: callback to execute after list updates.
  */

  function editTalk(options, $element) {
  
    var settings = {
      contextPath: "/franchise"
    };

    /* PRIVATE VARIABLES */

    var title = $('#talk_english_title', $element)
    var label = $('label[for=talk_english_title]', $element)
    var editLink = $('#edit-title', $element)
     
    /* PRIVATE METHODS */
    
    // constructor 
    function init() {
      if ( options ) { 
        $.extend( settings, options );
      }
      editableFields();
    }
  
    function editableFields() {
      if (!title.val()) {
        editLink.hide();
        return
      }
      label.hide();
      title.hide();
      var titleText = $('#title-text', $element).show();
      editLink.click(function () {
        title.show();
        titleText.hide();
        editLink.hide();
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
  $.fn.editTalk = function(options) {
    return this.each(function() {
      var $this = $(this);
     
      // Store plugin object in this element's data if it doesn't already exist 
      if (!$this.data('editTalk')) {
        $this.data('editTalk', editTalk(options, $this));
      }
    });
  };
})(jQuery);



