require "spec_helper"
require 'redmine_tiny_features/journals_controller_patch'

describe JournalsController, type: :controller do

  fixtures :users, :issues, :journals, :journal_details, :projects, :enabled_modules

  before do
    User.current = User.find(1)
    @request.session[:user_id] = 1 # admin
    Journal.create!(:journalized_id => Issue.find(1).id,
                    :journalized_type => 'Issue',
                    :user_id => User.current.id,
                    :notes => 'note_test',
                    :private_notes => 't'
    )
  end

  describe "Delete note" do
    it "delete note with details should empty the note and not destroy the journal" do
      JournalDetail.create!(:journal_id => Journal.last().id,
                      :property => 'attr',
                      :prop_key => 'subject',
                      :old_value => 'old_subject',
                      :value => 'new_subject'
      )
      expect {
        put(
          :update,
          :params => {
            :id => Journal.last().id,
            :journal => {
              :notes => ''
            }
          }
        )
      }. to change { Journal.count }.by(1)
        .and change { JournalDetail.count }.by(1)
        .and change { Journal.last().notes }.from('note_test').to('')
    end

    it "delete note without details should empty the note, destroy the journal, create another journal and journaldetails with property note" do
      expect {
        put(
          :update,
          :params => {
            :id => Journal.last().id,
            :journal => {
              :notes => ''
            }
          }
        )
      }. to change { Journal.count }.by(0)
        .and change { JournalDetail.count }.by(1)
        .and change { Journal.last().notes }.from('note_test').to('')
    end
  end

end