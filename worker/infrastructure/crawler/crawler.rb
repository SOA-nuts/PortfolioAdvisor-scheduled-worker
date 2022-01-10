# frozen_string_literal: true

require 'nokogiri'
require 'open-uri'
require 'net/http'
module PortfolioAdvisor
  module Crawler
    # Display content of HTML articles
    class Api
      attr_reader :url

      def initialize(url)
        @url = url
      end

      def crawl
        if working_url?(url)
          open_article = Nokogiri::HTML(URI.parse(@url).open)
          open_article.css('p').map(&:text)
        end
      rescue StandardError
        raise 'NotFound'
      end

      def working_url?(url_str)
        uri = URI(url_str)
        res = Net::HTTP.get_response(uri)
        res.is_a?(Net::HTTPSuccess)
      end
    end
  end
end
