module ApplicationHelper
  def full_tittle page_title =""
    base_title = t ".title"
    page_title.empty? ? base_title : page_title + " | " + base_title
  end        
end
