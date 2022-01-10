# frozen_string_literal: false

require 'date'
require 'http'

module PortfolioAdvisor
  module  GoogleNews
    # Library for Google News Web API
    class Api
      def initialize(token)
        @gn_token = token
      end

      def article(company, updated_at)
        article_req_url = Request.new(@gn_token).gn_api_path(company, updated_at)
        Request.new(@gn_token).get(article_req_url).parse
      end

      # Sends out HTTP requests to Google News Api
      class Request
        API_GOOGLE_NEWS_EVERYTHING = 'https://newsapi.org/v2/everything?'.freeze

        def initialize(token)
          @api_key = token
          @today = Date.today
        end

        def gn_api_path(company, updated_at)
          result_num = updated_at.nil? ? 15 : 5

          to = @today.strftime('%Y-%m-%d')
          from = updated_at.nil? ? (@today - 15).strftime('%Y-%m-%d') : to
          exclude_domains = 'makeuseof.com,cnet.com'
          "#{API_GOOGLE_NEWS_EVERYTHING}q=#{company}&from=#{from}&to=#{to}&pageSize=#{result_num}
          &language=en&sortBy=popularity&excludeDomains=#{exclude_domains}"
        end

        def get(url)
          http_response =
            HTTP.headers('Accept' => 'json',
                         'Authorization' => "token #{@api_key}")
              .get(url)

          Response.new(http_response).tap do |response|
            raise(response.error) unless response.successful?
          end
        end
      end

      # Decorates HTTP responses from NewsAPI with failure/success status
      class Response < SimpleDelegator
        Unauthorized = Class.new(StandardError)
        NotFound = Class.new(StandardError)
        BadRequest = Class.new(StandardError)
        HTTP_ERROR = {
          400 => BadRequest,
          401 => Unauthorized,
          404 => NotFound
        }.freeze

        def successful?
          !HTTP_ERROR.keys.include?(code)
        end

        def error
          HTTP_ERROR[code]
        end
      end
    end
  end
end
