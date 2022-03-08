require_dependency 'journals_helper'

module JournalsHelper
  def append_deleted_journal_to_history(deleted_journal)

    journal = deleted_journal.issue.journals.last
    journal.indice = deleted_journal.issue.journals.count
    s = +""
    #simulation of history (issue/notes)
    reply_links = deleted_journal.issue.notes_addable?

    content_span_a =
      content_tag('span', render_journal_actions(deleted_journal.issue, journal, :reply_links => reply_links).html_safe, :class => 'journal-actions') +
      content_tag('a', "#" + journal.indice.to_s, :href => "#note-#{journal.indice}", :class => 'journal-link')

    content_div_note = ""
    content_div_note += content_tag('div', content_span_a, :class => 'contextual')

    subject = h(avatar(journal.user).html_safe + authoring(journal.created_on, journal.user, :label => :label_updated_time_by).html_safe + render_private_notes_indicator(journal).html_safe)

    content_div_note += content_tag('h4', subject, :class => 'note-header')

    if  deleted_journal.issue.journals.last.details.any?
      content_div_note += content_tag(:ul, :class => 'details') do
        details_to_strings(deleted_journal.issue.journals.last.details).collect do |item|
          content_tag(:li, item)
        end.reduce(&:+)
      end
    end

    s << content_tag('div',
          content_tag('div', content_div_note.html_safe, :id => 'note-#{journal.indice}'),
          :id => 'change-#{journal.id}', :style => 'display: none;', :class => 'journal has-details'
        )
    s.html_safe
  end
end