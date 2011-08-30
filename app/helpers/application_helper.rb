module ApplicationHelper
  def application_name
    'Marpa Foundation Archive'
  end

  def render_document_heading
    begin
      render :partial=>"catalog/_header_partials/#{document_partial_name(@document)}"  
    rescue ActionView::MissingTemplate
      render :partial=>"catalog/_header_partials/default"
    end
  end


end
