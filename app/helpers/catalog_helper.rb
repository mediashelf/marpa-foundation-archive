module CatalogHelper

  # Overrides method in hydra_repository plugin's catalog_helper 
  def format_date date
   date.strftime("%b. %e, %Y")
  end
  
end