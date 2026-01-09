# frozen_string_literal: true

require "spec_helper"

describe "GanttPatch", type: :helper do

  describe "issue export pdf" do

    def assert_checksum(expected, filename)
      filepath = Rails.root.join(filename)
      checksum = Digest::MD5.hexdigest(File.read(filepath))
      assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
    end

    it "checks core helper checksums Redmine::Helpers::Gantt" do
      # These large standard methods are overridden: html_subject, html_task and render_object_row
      # Patches should be reviewed and adapted if there is any change in the core methods
      # Redmine 6.1.0 is validated
      assert_checksum %w"c37071820e2369d69b00caee9f561acc", "lib/redmine/helpers/gantt.rb"
    end

  end
end
