require 'nokogiri'
require 'httparty'

module Portholes

  # Portholes::Document parses the document with Nokogiri.
  class Document
    attr_reader :url, :title, :author, :body, :parser_used

    def initialize(url, last_parser)
      @url = Portholes::URL.untrack(url)
      @meta = Portholes::Parser.new(@url, parsed_document, last_parser)
      @title = @meta.title
      @author = @meta.author
      @body = @meta.body
      @parser_used = @meta.parser_used
    end

    def response
      request = HTTParty.get(@url)
      if request.response.code == '200'
        return request
      else
        raise "Article not found. Check the URL and try again."
      end
    end

    # Fetch document
    def document
      response.body
    end

    # Pasrse document with Nokogiri
    def parsed_document
      Nokogiri::HTML(document.to_s)
    end

  end

end
