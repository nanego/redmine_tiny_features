ENV['RAILS_ENV'] ||= 'test'
require File.expand_path('../../../../config/environment', __FILE__)
require File.expand_path("../../../redmine_base_rspec/spec/spec_helper", __FILE__)

RSpec.configure do |config|
  config.before(:each) do
    $testing_plugin = true
  end

  config.after(:each) do
    $testing_plugin = false
  end
end