#encoding: utf-8
Deface::Override.new :virtual_path  => "issues/_edit",
                     :name          => "add-warning-above-notes-textarea-if-issue-closed",
                     :insert_before => "erb[loud]:contains('text_area')",
                     :partial       => "issues/edit_closed"
Deface::Override.new :virtual_path  => "issues/_edit",
                     :name          => "add-span-required-when-notes-is-required-attribute",
                     :insert_after  => "erb[loud]:contains('l(:field_notes)')",
                     :text          => <<SAPN_NOTE
  <%= content_tag(:span, '*', class: 'required', id: 'span-notes', style: 'display:none') unless Rails.env.test? %>
<script>
  // show / hide required span, according required_attribute
  if (<%= @issue.required_attribute?('notes') %> == true){
    $("#span-notes").css('display', 'inline');
  } else {
    $("#span-notes").css('display', 'none');
  }
</script>
SAPN_NOTE