# frozen_string_literal: false

require 'date'

require_relative 'content_mapper'

module PortfolioAdvisor
  # Access article data
  module GoogleNews
    # Maps NewsAPI data to Article Entity
    class ArticleMapper
      def initialize; end

      # Without concurrency
      def load_several(articles)
        articles.map do |article|
          ArticleMapper.build_entity(article)
        end
      end

      # With concurrency
      def load_several_concurrently(articles)
        articles.map do |article|
          Concurrent::Promise
            .execute { ArticleMapper.build_entity(article) }
        end.map(&:value)
      end

      def self.build_entity(article)
        DataMapper.new(article).build_entity
      end

      # Extracts specific parameters from data
      class DataMapper
        def initialize(data)
          @data = data
          @publish_at = DateTime.strptime(@data['publishedAt'], '%Y-%m-%dT%H:%M:%S%z')
          @content_mapper = ContentMapper.new(@data['url'])
        end

        def build_entity
          PortfolioAdvisor::Entity::Article.new(
            url: url,
            published_at: published_at,
            title: title,
            score: score
          )
        end

        private

        def url
          @data['url']
        end

        def score
          # for debug
          puts url
          puts title
          puts '...'
          @content_mapper.crawl_content.score
        end

        def published_at
          DateTime.strptime(@data['publishedAt'], '%Y-%m-%dT%H:%M:%S%z')
        end

        def title
          @data['title']
        end
      end
    end
  end
end
