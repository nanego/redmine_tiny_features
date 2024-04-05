# frozen_string_literal: true

require 'pdf/reader'
require "spec_helper"

describe "IssuesPdfHelperPatch", type: :helper do
  include Redmine::Export::PDF::IssuesPdfHelper
  include ApplicationHelper
  fixtures :issues, :attachments

  describe "issue export pdf" do

    it "includes a link for each attached file" do
      issue = Issue.find(2)
      result = issue_to_pdf(issue)
      pdf_reader = PDF::Reader.new(StringIO.new(result))

      expect(pdf_reader.pages.any? { |page| page.text.include?(issue.subject.to_s) }).to be_truthy, "The expected subject is not present in the PDF"

      expect(issue.attachments.size).to eq 2
      expect(result).to include "URI (http://test.host/attachments/4)"
      expect(result).to include "URI (http://test.host/attachments/10)"
    end

    def assert_checksum(expected, filename)
      filepath = Rails.root.join(filename)
      checksum = Digest::MD5.hexdigest(File.read(filepath))
      assert checksum.in?(Array(expected)), "Bad checksum for file: #{filename}, local version should be reviewed: checksum=#{checksum}, expected=#{Array(expected).join(" or ")}"
    end

    it "checks core helper checksums Redmine::Export::PDF::IssuesPdfHelper" do
      # the issue_to_pdf method is completely overridden, so it should be updated if the core method is modified
      # Redmine 4.2.11 & 5.1.2 are validated
      assert_checksum %w"c9a65d240988113acc0d3ab1ff0521b9 83ce301735da9b092f59e2865dea7349", "lib/redmine/export/pdf/issues_pdf_helper.rb"
    end

  end
end
