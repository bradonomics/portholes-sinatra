require 'nokogiri'
require 'httparty'

module Portholes

  # Portholes::Document parses the document with Nokogiri.
  class Document
    attr_reader :url, :title, :author, :body

    def initialize(url)
      @url = Portholes::URL.untrack(url)
      @meta = Portholes::Parser.new(@url, parsed_document)
      @title = @meta.title
      @author = @meta.author
      @body = @meta.body
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
