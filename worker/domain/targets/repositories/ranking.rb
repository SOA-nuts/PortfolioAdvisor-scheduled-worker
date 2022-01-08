# frozen_string_literal: true

module PortfolioAdvisor
    module Repository
      # Repository for Analysis Entities
      class Rank
        def self.find_id(id)
          rebuild_entity Database::RankOrm.first(id: id)
        end
  
        def self.all
          Database::RankOrm.all
        end
  
        def self.find_rank
          Database::RankOrm.last
        end
  
        def self.create(entity)
            Database::RankOrm.create(entity.to_hash)
        end
        def self.db_find_or_create(entity)
          Database::RankOrm.find_or_create(entity.to_hash)
        end
      end
    end
  end
  