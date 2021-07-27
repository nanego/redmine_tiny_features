module RedmineTinyFeatures
  class Hooks < Redmine::Hook::ViewListener
    #adds our css on each page
    def view_layouts_base_html_head(context)
      stylesheet_link_tag("tiny_features", :plugin => "redmine_tiny_features")+
      javascript_include_tag('redmine_tiny_features.js', plugin: 'redmine_tiny_features')
    end
  end
end
