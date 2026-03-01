require 'nokogiri'
require 'uri'
require 'json'
require 'open3'

module Portholes
  class Parser

    def initialize(url, document, last_parser)
      @url = url
      @document = document
      @last_parser = last_parser
    end

    def title
      find_title
      # This is an extra method, sure. But it's here in case I need to do
      # something with the title after I find it.
    end

    def author
      find_author
      # This is an extra method, sure. But it's here in case I need to do
      # something with the author after I find it.
    end

    def body
      poorly_parsed_urls = ['newyorker.com']
      if @last_parser == 'mozilla' || poorly_parsed_urls.any? { |domain| URI.parse(@url).host.include?(domain) }
        document_parser
      else # Send document to Readability for parsing
        preprocess_headings_for_readability!

        parsed_document, status = Open3.capture2(
          "node lib/readability.js '#{@url}'",
          stdin_data: @document.to_html
        )
        if status.success?
          @parser_used = 'mozilla'
          return parsed_document.to_s
        else
          document_parser
        end
      end
    end

    def parser_used
      return @parser_used
    end

    private

      def find_title
        candidates = [ # list candidates by priority
          # TODO: This needs some more safistication. The H1 is probably what
          # we want, but it needs to be checked if it's in an article tag first.
          # Problem sites:
          # - https://erikhoel.substack.com/p/why-we-stopped-making-einsteins
          # - https://www.schneier.com/blog/archives/2022/02/a-new-cybersecurity-social-contract.html
          # Failing that, we could check for the site name after a | or — or -
          # but that will likely take much more code.
          @document.title,
          @document.css('meta[@name="title"]/@content').to_s,
          @document.css('meta[@property="og:title"]/@content').to_s,
          @document.css('h1').first,
        ]
        best_candidate(candidates)
      end

      def find_author
        candidates = [
          @document.css('meta[@name="author"]/@content').to_s,
          @document.css('a[rel="author"]').first,
          @document.css('meta[@name="twitter:data1"]/@content').to_s,
        ]
        json = @document.css('script[type="application/ld+json"]').text
        unless json.empty? || JSON[json]['author'].nil?
          candidates.insert(1, JSON[json]['author']['name'])
        end
        best_candidate(candidates)
      end

      def best_candidate(candidates)
        candidates.flatten! # single level array
        candidates.compact! # strip nil elements
        candidates.map! { |c| (c.respond_to? :inner_text) ? c.inner_text : c } # return only the text (strips the HTML)
        candidates.map! { |c| c.strip.gsub(/\s+/, ' ') } # replace multiple spaces with a single space
        candidates.reject!(&:empty?) # strip empty strings
        candidates.first
      end

      def document_parser
        # Find article content
        if @document.at_css("article")
          article = @document.at_css("article")
        elsif @document.at_css("main")
          article = @document.at_css("main")
        elsif @document.at_css('[id="content"]')
          article = @document.at_css('[id="content"]')
        else
          article = @document.at_css("body")
        end

        # Remove unwanted elements by class/id
        # TODO: make case insensitive to shorten file length
        file = File.join('lib', 'removal_list')
        File.readlines(file, chomp: true).each do |line|
          article.xpath("//*[@*[contains(., '#{line}')]]").each do |node|
            node.remove
          end
        end

        @parser_used = 'portholes'
        return article.to_s
      end

      def preprocess_headings_for_readability!
        headers = @document.css("h1, h2, h3, h4, h5, h6")

        headers.each do |header|
          # Remove class and id attributes (prevents negative scoring in Readability)
          header.remove_attribute("class")
          header.remove_attribute("id")

          # Capture plain text content
          text_content = header.text

          # Remove all child nodes (e.g., Substack anchor divs)
          header.children.remove

          # Restore only the clean text
          header.content = text_content
        end
      end

  end
end

if __FILE__ == $0
  # url = URI.parse("https://www.newyorker.com/culture/personal-history/notes-on-work")
  # poorly_parsed_urls = ['newyorker.com']
  # puts poorly_parsed_urls.any? { |i| url.host.include? i }
  # puts url.host
  # puts url.host.include?('newyorker.com')


#   doc = Nokogiri::HTML(<<EOT)
#     <div id="readability-page-1" class="page"><div>
#     <article>
#     <p>I come from Alabama. Somebody has to. In my early years, I lived in the south of the state, near Mobile. When I was thirteen or so, my father got a job in north Alabama, near Huntsville. Both places are rural. Scottsboro, the town where I went to high school, is about 15,000 people. I live 12 miles out of town. I can see my neighbor’s house but it’s far enough I can’t hear them unless they’re running a lawnmower or a chainsaw. That’s right, in Alabama we say running, not using.</p>
#     </article>
#     </div></div>
# EOT

#   foo_spans = doc.search('.page')
#   foo_spans.each do |n|
#     n['class'] = n['class'].gsub(/\bpage\b/, 'portholes-page')
#   end

#   puts doc.to_s
end
