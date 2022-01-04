# frozen_string_literal: false

require_relative 'article_mapper'

module PortfolioAdvisor
  module YahooFinance
    # Data Mapper: News repo -> Target entity
    class FinanceMapper
      def initialize(yahoo_token, gateway_class = YahooFinance::Api)
        @token = yahoo_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(company_symbol)
        summary = @gateway.financial_data(company_symbol)
        build_entity(summary['quoteSummary']['result'][0]['financialData'])
      end

      def build_entity(summary)
        DataMapper.new(summary).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(summary)
          @bench_price = summary['targetMedianPrice']['raw']
          @market_price = summary['currentPrice']['raw']
          @grow_score = summary['revenueGrowth']['raw']
        end

        def build_entity
          PortfolioAdvisor::Entity::Finance.new(
            market_price: market_price,
            grow_score: grow_score,
            bench_price: bench_price
          )
        end

        attr_reader :market_price, :bench_price, :grow_score
      end
    end
  end
end
