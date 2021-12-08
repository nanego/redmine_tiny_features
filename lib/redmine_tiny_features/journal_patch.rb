require_dependency 'journal'

class Journal < ActiveRecord::Base

  # Adds a journal detail for a note that was removed
  def journalize_note
    details <<
      JournalDetail.new(
        :property => 'note',
      )
  end

end
