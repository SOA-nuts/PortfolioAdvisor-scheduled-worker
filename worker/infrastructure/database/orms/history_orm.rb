# frozen_string_literal: true

require 'sequel'

module PortfolioAdvisor
  module Database
    # Object-Relational Mapper for histories
    class HistoryOrm < Sequel::Model(:histories)
      many_to_one :company,
                  class: :'PortfolioAdvisor::Database::TargetOrm'

      plugin :timestamps, update_on_create: true

      def self.find_or_create(history)
        first(company_id: history[:company_id], updated_at: history[:updated_at]) || create(history)
      end
    end
  end
end
