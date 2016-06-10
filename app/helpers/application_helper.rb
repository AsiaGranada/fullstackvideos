module ApplicationHelper

  def resource_name
    :user
  end

  def resource
    @resource ||= User.new
  end

  def devise_mapping
    @devise_mapping ||= Devise.mappings[:user]
  end

  def smart_link_to(anchor, url, html_options = {})
    hide_or_not = 'hidden' if current_page?(url)
    content_tag :li, class: hide_or_not do
      link_to anchor, url, html_options
    end
  end

end
