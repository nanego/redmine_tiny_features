require "spec_helper"

describe JournalsController, type: :controller do

  fixtures :projects, :users, :members, :member_roles, :roles,
           :issues, :journals, :journal_details, :enabled_modules,
           :trackers, :issue_statuses, :enumerations, :custom_fields,
           :custom_values, :custom_fields_projects, :projects_trackers

  # before do
  #   User.current = User.find(1)
  #   @request.session[:user_id] = 1 # admin
  #   Journal.create!(:journalized_id => Issue.find(1).id,
  #                   :journalized_type => 'Issue',
  #                   :user_id => User.find(2).id,
  #                   :notes => 'note_test',
  #                   :private_notes => 't'
  #   )
  #   Setting.send "plugin_redmine_tiny_features=", {
  #     "warning_message_on_closed_issues"=>"1",
  #     "default_open_status"=>"2",
  #     "default_project"=>"1",
  #     "use_select2"=>"1",
  #     "paginate_issue_filters_values"=>"1",
  #     "journalize_note_deletion"=>"1"
  #   }
  # end
  #
  # describe "Delete note" do
  #   it "delete note with details should empty the note and not destroy the journal" do
  #     JournalDetail.create!(:journal_id => Journal.last().id,
  #                     :property => 'attr',
  #                     :prop_key => 'subject',
  #                     :old_value => 'old_subject',
  #                     :value => 'new_subject'
  #     )
  #     expect {
  #       put(
  #         :update,
  #         :params => {
  #           :id => Journal.last().id,
  #           :journal => {
  #             :notes => ''
  #           }
  #         }
  #       )
  #     }. to change { Journal.count }.by(1)
  #       .and change { JournalDetail.count }.by(1)
  #       .and change { Journal.last().notes }.from('note_test').to('')
  #   end
  #
  #   it "delete note without details should empty the note, destroy the journal, create another journal and journaldetails with property note" do
  #     expect {
  #       put(
  #         :update,
  #         :params => {
  #           :id => Journal.last().id,
  #           :journal => {
  #             :notes => ''
  #           }
  #         }
  #       )
  #     }. to change { Journal.count }.by(0)
  #       .and change { JournalDetail.count }.by(1)
  #       .and change { Journal.last().notes }.from('note_test').to('')
  #   end
  # end

end