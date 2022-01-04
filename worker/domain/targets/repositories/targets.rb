# frozen_string_literal: true

module PortfolioAdvisor
  module Repository
    # Repository for Target
    class Targets
      def self.all
        Database::TargetOrm.all
      end

      def self.check_status(company_name)
        record = Database::TargetOrm
          .where(company_name: company_name)
          .first
        TargetStatus.new(record)
      end

      def self.find_company(company_name)
        Database::TargetOrm
          .where(company_name: company_name)
          .first
      end

      def self.find_companys(company_names)
        company_names.map do |company_name|
          find_company(company_name)
        end.compact
      end

      def self.find(entity)
        find_company(entity.company_name)
      end

      def self.update(entity)
        target = find(entity)
        PersistTarget.new(entity).update(target)
      end

      def self.create(entity)
        raise 'Target already exists' if find(entity)

        PersistTarget.new(entity).call
      end

      # Helper to save target and its articles
      class PersistTarget
        def initialize(entity)
          @entity = entity
        end

        def create_target
          Database::TargetOrm.create(@entity.to_attr_hash)
        end

        def create_history
          Database::HistoryOrm.create(@entity.to_history_hash)
        end

        def call
          create_target.tap do |db_target|
            create_history.tap do |db_history|
              db_history.update(company: db_target)
            end
            @entity.articles.each do |article|
              db_target.add_article(Articles.db_find_or_create(article))
              Articles.db_find_or_create(article)
            end
          end
        end

        def update(target)
          company = target.update(updated_at: @entity.updated_at)

          @entity.articles.each do |article|
            target.add_article(Articles.db_find_or_create(article))
          end

          create_history.tap do |db_history|
            db_history.update(company: company)
          end

          company
        end
      end
    end
  end
end
