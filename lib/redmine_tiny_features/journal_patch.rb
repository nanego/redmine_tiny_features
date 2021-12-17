require_dependency 'journal'

class Journal < ActiveRecord::Base

  # Adds a journal detail for a note that was removed
  def journalize_note(journal)
    details <<
      JournalDetail.new(
        :property => 'note',
        :prop_key => journal.user.id,
        :old_value => journal.id
      )
  end

end
