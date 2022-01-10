# frozen_string_literal: true

module PortfolioAdvisor
  module Repository
    # Repository for Article Entities
    class Articles
      def self.find_id(id)
        rebuild_entity Database::ArticleOrm.first(id: id)
      end

      def self.rebuild_entity(db_record)
        return nil unless db_record

        Entity::Article.new(
          id: db_record.id,
          company_id: db_record.company_id,
          title: db_record.title,
          url: db_record.url,
          published_at: DateTime.parse(db_record.published_at.to_s),  # todo
          score: db_record.score
        )
      end

      def self.rebuild_many(db_records)
        db_records.map do |db_article|
          Articles.rebuild_entity(db_article)
        end
      end

      def self.db_find_or_create(entity)
        Database::ArticleOrm.find_or_create(entity.to_hash)
      end
    end
  end
end
