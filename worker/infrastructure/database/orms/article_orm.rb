# frozen_string_literal: true

require 'sequel'

module PortfolioAdvisor
  module Database
    # Object-Relational Mapper for articles
    class ArticleOrm < Sequel::Model(:articles)
      many_to_one :target,
                  class: :'PortfolioAdvisor::Database::TargetOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(article_info)
        first(url: article_info[:url]) || create(article_info)
      end
    end
  end
end
