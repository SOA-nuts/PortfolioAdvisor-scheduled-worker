# frozen_string_literal: false

require 'http'

module PortfolioAdvisor
  module  YahooFinance
    # Library for Yahoo Finance Web API
    class Api
      def initialize(token)
        @api_key = token
      end

      def financial_data(company_symbol)
        summary_req_url = Request.new(@api_key).yahoo_api_path(company_symbol)
        Request.new(@api_key).get(summary_req_url).parse
      end

      # Sends out HTTP requests to Google News Api
      class Request
        API_YAHOO_FINANCE_SUMMARY = 'https://query1.finance.yahoo.com/v11/finance/quoteSummary/'.freeze

        def initialize(token)
          @api_key = token
        end

        def yahoo_api_path(company_symbol)
          "#{API_YAHOO_FINANCE_SUMMARY}#{company_symbol}?modules=financialData"
        end

        def get(url)
          http_response =
            # HTTP.headers('Accept'        => 'json',
            #              'x-api-key'     => @api_key)
            #   .get(url)
            HTTP.headers(
              'x-api-key' => @api_key
            ).get(url)

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
        NotAcceptable = Class.new(StandardError)
        HTTP_ERROR = {
          400 => BadRequest,
          401 => Unauthorized,
          404 => NotFound,
          406 => NotAcceptable
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
