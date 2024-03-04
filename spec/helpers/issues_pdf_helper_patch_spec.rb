# frozen_string_literal: true

require 'pdf/reader'
require "spec_helper"

describe "IssuesPdfHelperPatch", type: :helper do
  include Redmine::Export::PDF::IssuesPdfHelper
  include ApplicationHelper
  fixtures :issues, :attachments

  describe "issue export pdf" do
    it "Should create attachment links" do
      issue = Issue.find(2)
      result = issue_to_pdf(issue)
      pdf_reader = PDF::Reader.new(StringIO.new(result))

      assert pdf_reader.pages.any? { |page| page.text.include?(issue.subject.to_s) }, "The expected subject is not present in the PDF"

      issue.attachments.each do |attachment|
        assert_equal(true, result.include?("(http://test.host/attachments/#{attachment.id})"))
      end
    end
  end
end
