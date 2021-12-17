require_dependency 'journals_controller'

class JournalsController

  def update
    (render_403; return false) unless @journal.editable_by?(User.current)
    @journal.safe_attributes = params[:journal]
    @journal.save

    if  !Setting["plugin_redmine_tiny_features"]["journalize_note_deletion"].present?
      @journal.destroy if @journal.details.empty? && @journal.notes.blank?
    else
      # to trace deletion of note
      if @journal.notes.blank?
        @journal.issue.init_journal(User.current)
        @journal.issue.note_removed(@journal)
        @journal.destroy if @journal.details.empty?
      end
    end
    call_hook(:controller_journals_edit_post, {:journal => @journal, :params => params})
    respond_to do |format|
      format.html {redirect_to issue_path(@journal.journalized)}
      format.js
    end
  end
end