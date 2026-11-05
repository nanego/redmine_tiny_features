require "spec_helper"

describe ApplicationHelper, type: :helper do
  headings = {
    "L'adresse de l'agent" => 'Ladresse-de-lagent',
    'Le "guide" & la suite' => 'Le-guide-amp-la-suite',
    'Sans ponctuation' => 'Sans-ponctuation'
  }

  { 'textile' => 'h2.', 'common_mark' => '##' }.each do |format, prefix|
    context "with the #{format} formatter" do
      headings.each do |heading, anchor|
        it "keeps a stable anchor and a readable table of contents for the heading: #{heading}" do
          with_settings text_formatting: format do
            html = Nokogiri::HTML5.fragment(helper.textilizable("{{toc}}\n\n#{prefix} #{heading}\n\n[[##{anchor}|link]]"))

            expect(html.at_css('a[name]')['name']).to eq anchor
            expect(html.at_css('ul.toc a')['href']).to eq "##{anchor}"
            expect(html.at_css('ul.toc a').text).to eq heading
            expect(html.at_css('a.wiki-page')['href']).to eq "##{anchor}"
          end
        end
      end
    end
  end
end
