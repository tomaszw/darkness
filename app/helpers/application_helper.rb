# Methods added to this helper will be available to all templates in the application.
module ApplicationHelper
  def sort_td_class_helper(param)
    result = 'class="sortup"' if @params[:sort] == param
    result = 'class="sortdown"' if @params[:sort] == param + "_reverse"
    return result
  end
  def sort_link_helper(text, param)
    key = param
    key += "_reverse" if @params[:sort] == param
    options = {
      :url => {:action => 'list', :params => @params.merge({:sort => key, :page => nil})},
      :update => 'table',
      :before => "Element.show('spinner')",
      :success => "Element.hide('spinner')",
    }
    html_options = {
      :title => "Sort by this field",
      :href => url_for(:action => 'list', :params => @params.merge({:sort => key, :page => nil}))
    }
    link_to_remote(text, options, html_options)
  end
  
  def text_field_with_auto_complete(object, method, tag_options = {}, completion_options = {})
    text_field(object, method, tag_options) +
    content_tag("div", "", :id => "#{object}_#{method}_auto_complete", :class => "auto_complete") +
    auto_complete_field("#{object}_#{method}", { :url => { :action => "auto_complete_for_#{object}_#{method}" } }.update(completion_options))
  end
  
  def tr_class(i)
    if i%2==0
      " class = \"even\" "
    else
      " class = \"odd\" "
    end
  end
end
