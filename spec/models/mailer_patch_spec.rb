require "spec_helper"
require "rails_helper"

describe "Mailer" do

  include ActiveSupport::Testing::Assertions

  fixtures :users, :email_addresses, :user_preferences,
           :roles, :members, :member_roles,
           :issues, :issue_statuses, :issue_relations,
           :versions, :trackers, :projects_trackers,
           :issue_categories, :enabled_modules, :enumerations,
           :projects

  it "does not send reminders for older issues when using max_delay option" do

    user = User.find(2)
    user.pref.update_attribute :time_zone, 'UTC'

    Issue.generate!(:assigned_to => user, :due_date => 20.days.from_now, :subject => 'quux')
    Issue.generate!(:assigned_to => user, :due_date => 0.days.from_now, :subject => 'baz')
    Issue.generate!(:assigned_to => user, :due_date => 1.days.from_now, :subject => 'qux')
    Issue.generate!(:assigned_to => user, :due_date => 10.days.ago, :subject => 'foo')
    Issue.generate!(:assigned_to => user, :due_date => 100.days.ago, :subject => 'bar')
    ActionMailer::Base.deliveries.clear

    Mailer.reminders(:days => 7, :users => [user.id], :max_delay => 30)

    assert_equal 1, ActionMailer::Base.deliveries.size

    email = ActionMailer::Base.deliveries.last
    expect(email).to_not be_nil

    mail_boy = email.parts.first.body.encoded

    expect(mail_boy).to_not match(/quux/)
    expect(mail_boy).to match(/foo \(10 days late\)/)
    expect(mail_boy).to match(/baz \(Due in 0 days\)/)
    expect(mail_boy).to match(/qux \(Due in 1 day\)/)
    expect(mail_boy).to_not match(/bar/)

  end

  describe "Reply-To header" do
    def deliver_issue_add_with_reply_to_address(address)
      settings = Setting["plugin_redmine_tiny_features"].merge("reply_to_address" => address)
      with_settings "plugin_redmine_tiny_features" => settings do
        ActionMailer::Base.deliveries.clear
        Mailer.deliver_issue_add(Issue.find(1))
      end
      expect(ActionMailer::Base.deliveries).to_not be_empty
      ActionMailer::Base.deliveries.last
    end

    it "adds the configured Reply-To header to outgoing emails" do
      email = deliver_issue_add_with_reply_to_address("replies@example.net")

      expect(email.reply_to).to eq ["replies@example.net"]
    end

    it "does not add a Reply-To header when no address is configured" do
      email = deliver_issue_add_with_reply_to_address("")

      expect(email.reply_to).to be_nil
    end
  end
end
