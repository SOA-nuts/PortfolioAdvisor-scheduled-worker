# frozen_string_literal: false

require 'concurrent'

require_relative 'article_mapper'

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: News repo -> Target entity
    class TargetMapper
      def initialize(gn_token, gateway_class = GoogleNews::Api)
        @token = gn_token
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@token)
      end

      def find(company, company_symbol, updated_at)
        data = @gateway.article(company, updated_at)
        build_entity(company, data['articles'], company_symbol)
      end

      def build_entity(company, data, company_symbol)
        DataMapper.new(company, data, company_symbol).build_entity
      end

      # Extracts entity specific elements from data structure
      class DataMapper
        def initialize(company, data, company_symbol)
          @company_name = company
          @articles = ArticleMapper.new.load_several(data)
          @finance_data = PortfolioAdvisor::YahooFinance::FinanceMapper.new(AddTargetWorker.config.YAHOO_TOKEN)
            .find(company_symbol)
        end

        def build_entity
          @article_score = article_score
          @bench_price = bench_price
          @grow_score = grow_score
          @long_advice_price = advice_price(1, 0.8)
          @mid_advice_price = advice_price(2.5, 0.5)
          @short_advice_price = advice_price(4, 0.2)

          PortfolioAdvisor::Entity::Target.new(
            company_name: company_name,
            updated_at: Date.today,
            articles: articles,
            market_price: market_price,
            long_advice_price: @long_advice_price,
            mid_advice_price: @mid_advice_price,
            short_advice_price: @short_advice_price,
            long_term_advice: advice(@long_advice_price),
            mid_term_advice: advice(@mid_advice_price),
            short_term_advice: advice(@short_advice_price)
          )
        end

        attr_reader :company_name, :articles

        def article_score
          @articles.map(&:score).sum / @articles.size / 100
        end

        def grow_score
          @finance_data.grow_score
        end

        def bench_price
          @finance_data.bench_price
        end

        def market_price
          @finance_data.market_price
        end

        def advice_price(article_weight, grow_weight)
          @bench_price * (0.7 + (@article_score * article_weight) + (@grow_score * grow_weight))
        end

        def advice(advice_price)
          percent = market_price / advice_price
          if percent < 0.85
            'excellent'
          elsif percent < 0.95
            'good'
          elsif percent < 1.05
            'fair'
          elsif percent < 1.15
            'poor'
          else
            'bad'
          end
        end
      end
    end
  end
end
