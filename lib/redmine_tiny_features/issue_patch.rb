class Issue < ActiveRecord::Base
  def note_removed(journal)
    if current_journal && !journal.new_record?
      current_journal.journalize_note(journal)
      current_journal.save
    end
  end
end