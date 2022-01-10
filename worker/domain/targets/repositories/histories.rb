# frozen_string_literal: true

module PortfolioAdvisor
  module Repository
    # Repository for Analysis Entities
    class Histories
      def self.find_id(id)
        rebuild_entity Database::HistoryOrm.first(id: id)
      end

      def self.all
        Database::HistoryOrm.all
      end

      def self.find_company(company_name)
        company_id = Database::TargetOrm
          .where(company_name: company_name)
          .first.id

        Database::HistoryOrm
          .where(company_id: company_id)
      end

      def self.db_find_or_create(entity)
        Database::HistoryOrm.find_or_create(entity)
      end
    end
  end
end
