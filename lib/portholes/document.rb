require 'nokogiri'
require 'http'

module Portholes

  # Portholes::Document parses the document with Nokogiri.
  class Document
    attr_reader :url, :title, :author, :body, :parser_used

    def initialize(url, last_parser)
      @url = Portholes::URL.untrack(url)
      @meta = Portholes::Parser.new(@url, document, last_parser)
      @title = @meta.title
      @author = @meta.author
      @body = @meta.body
      @parser_used = @meta.parser_used
    end

    def response
      # https://webmasters.stackexchange.com/questions/126452/what-headers-used-in-request-by-google-bot
      # https://www.searchdatalogy.com/blog/googlebots-http-headers/
      # https://developers.google.com/search/docs/advanced/crawling/overview-google-crawlers
      http = HTTP.headers("User-Agent" => "Mozilla/5.0 (compatible; Googlebot/2.1; +http://www.google.com/bot.html)")
      request = http.get(@url)
      unless request.code == 200
        request = HTTP.get(@url)
      end
      return request.to_s
    rescue
      raise "Article not found. Check the URL and try again."
    end

    # Pasrse document with Nokogiri
    def document
      document = Nokogiri::HTML(response)
      # Remove non-article elements before sending to parser
      document.search('aside', 'script', 'noscript', 'style', 'nav', 'video', 'audio', 'form', 'button', 'fbs-ad', 'map', 'svg').remove
      return document
    end

  end

end
