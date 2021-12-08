require_dependency 'journals_controller'

class JournalsController

  def update
    (render_403; return false) unless @journal.editable_by?(User.current)
    @journal.safe_attributes = params[:journal]
    @journal.save

    # replace this line
    #@journal.destroy if @journal.details.empty? && @journal.notes.blank?

    # by
    if @journal.notes.blank?
      @journal.issue.init_journal(User.current)
      @journal.issue.note_removed(@journal)
      @journal.destroy if @journal.details.empty?
    end
    # to trace deletion of note

    call_hook(:controller_journals_edit_post, {:journal => @journal, :params => params})
    respond_to do |format|
      format.html {redirect_to issue_path(@journal.journalized)}
      format.js
    end
  end
end