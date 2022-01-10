# frozen_string_literal: true

require 'sequel'

module PortfolioAdvisor
  module Database
    # Object Relational Mapper for Target Entities
    class TargetOrm < Sequel::Model(:targets)
      one_to_many :articles,
                  class: :'PortfolioAdvisor::Database::ArticleOrm',
                  key: :company_id

      one_to_many :histories,
                  class: :'PortfolioAdvisor::Database::HistoryOrm',
                  key: :company_id

      plugin :timestamps, update_on_create: true, update: :updated_on
    end
  end
end
