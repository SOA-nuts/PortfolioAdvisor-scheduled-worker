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

      def article(company)
        article_req_url = Request.new(@gn_token).gn_api_path(company)
        Request.new(@gn_token).get(article_req_url).parse
      end

      # Sends out HTTP requests to Google News Api
      class Request
        API_GOOGLE_NEWS_EVERYTHING = 'https://newsapi.org/v2/everything?'.freeze

        def initialize(token)
          @api_key = token
          @today = Date.today
        end

        def gn_api_path(company)
          time = @today.strftime('%Y-%m-%d')
          "#{API_GOOGLE_NEWS_EVERYTHING}q=#{company}&from=#{time}&to=#{time}&pageSize=15&language=en"
        end

        def get(url)
          http_response =
            HTTP.headers('Accept'        => 'json',
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
