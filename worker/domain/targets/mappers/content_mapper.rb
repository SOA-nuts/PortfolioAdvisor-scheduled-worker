# frozen_string_literal: true

module PortfolioAdvisor
  module GoogleNews
    # Data Mapper: url -> call score mapper
    class ContentMapper
      def initialize(url, gateway_class = Crawler::Api)
        @url = url
        @gateway_class = gateway_class
        @gateway = @gateway_class.new(@url)
      end

      def build_entity(content)
        DataMapper.new(content).build_entity
      end

      def crawl_content
        content = @gateway.crawl
        build_entity(content)
      end
    end

    # Extracts specific parameters from data
    class DataMapper
      def initialize(content)
        @content = content
      end

      def build_entity
        Entity::Content.new(
          content: @content
        )
      end
    end
  end
end
