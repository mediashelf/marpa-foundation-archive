(function($) {
  
  datePickerOpts = {
    dateFormat: 'yy-mm-dd',
    partialDateFormats: ['yy-mm', 'yy'],
    allowShortYear: false,
    ignoreTrailingCharacters: false
  }
  
  validateDate = function(event) {
    try {
        $.datepicker.parseDate(
          $.data(event.target, 'datepicker'),
          event.target.value)
        $(event.target).removeClass('error')
      } catch(err) {
        // Wait to highlight error until user is done typing
        if(event.type != 'keyup')
          $(event.target).addClass('error')
    }
  }
  
  $(document).ready(function() {
    $('.datepicker').datepicker(datePickerOpts).change(validateDate).keyup(validateDate)
  })
  
})(jQuery)
