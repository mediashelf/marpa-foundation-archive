module LibraHelper
  
  def display_release_status_notice(document)
    flash[:notice] ||= []
    readiness = document.test_release_readiness
    if !readiness == true
      flash[:notice] = flash[:notice] | readiness[:failures]
    else
      if document.submitted_for_release?
        flash[:notice] << "This item has been released for library circulation."
      else
        flash[:notice] << "This item is ready to be released for library circulation."
      end
    end
  end
  
end