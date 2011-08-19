(function($){

  /* options
  */

  function editProgram(options, $element) {
  
    var settings = {
    };

    /* PRIVATE VARIABLES */

    
     
    /* PRIVATE METHODS */
    
    // constructor 
    function init() {
      if ( options ) { 
        $.extend( settings, options );
      }
      editableFields();
      addButtons();
    }
  
    function editableFields() {
      var title = $('#program_title', $element).hide();
      var titleText = $('#title-text', $element).show();
      $('#edit-title', $element).click(function () {
        title.show();
        titleText.hide();
        return false;
      });

    }

    function addButtons() {
      $("input[type=button]", $element).click(function(e) {
        var button = $(e.currentTarget);
        var field = button.attr('data-field');
        var value = $("#"+field).val();
        var params = new Object();
        params[field] = value;
        $.post(button.attr('data-path'), params,
            function(data) {
              button.closest('tr').before(data); 
            }
        );
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
  $.fn.editProgram = function(options) {
    return this.each(function() {
      var $this = $(this);
     
      // Store plugin object in this element's data if it doesn't already exist 
      if (!$this.data('editProgram')) {
        $this.data('editProgram', editProgram(options, $this));
      }
    });
  };
})(jQuery);



