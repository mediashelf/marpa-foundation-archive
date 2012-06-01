(function($){

  function editTalk(options, $element) {
  
    var settings = {
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
      addButtons();
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


    function addButtons() {
      $("input[type=button]", $element).click(function(e) {
        var button = $(e.currentTarget);
        var field = button.attr('data-field');
        var value = $("#"+field).val();
        var params = new Object();
        params[field] = value;
        $.post(button.attr('data-path'), params,
            function(data) {
              $('table.associated-texts tbody', $element).html(data); 
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



