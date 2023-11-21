require_dependency 'journal'

module RedmineTinyFeatures::JournalPatch
  # Adds a journal detail for a note that was removed
  def journalize_note(journal)
    details <<
      JournalDetail.new(
        :property => 'note',
        :prop_key => journal.user.id,
        :old_value => journal.id
      )
  end

  def note_removed(journal)
    if !journal.new_record?
      journalize_note(journal)
      save!
    end
  end
end

Journal.prepend RedmineTinyFeatures::JournalPatch
