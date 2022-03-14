require "spec_helper"
require "rails_helper"

describe "Mailer" do

  include ActiveSupport::Testing::Assertions

  fixtures :users, :email_addresses, :user_preferences,
           :roles, :members, :member_roles,
           :issues, :issue_statuses, :issue_relations,
           :versions, :trackers, :projects_trackers,
           :issue_categories, :enabled_modules, :enumerations

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
end
