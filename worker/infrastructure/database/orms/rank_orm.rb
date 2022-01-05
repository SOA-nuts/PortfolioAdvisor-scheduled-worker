# frozen_string_literal: true

require 'sequel'

module PortfolioAdvisor
  module Database
    # Object-Relational Mapper for histories
    class RankOrm < Sequel::Model(:ranks)
      plugin :timestamps, update_on_create: true

      def self.find_or_create(rank)
        first(updated_at: rank[:updated_at]) || create(rank)
      end
    end
  end
end
