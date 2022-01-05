# frozen_string_literal: false

module PortfolioAdvisor
  # Access article data
  module Mapper
    # Maps rank
    class Rank
        def initialize(search_request)
            @search_request = search_request
            @update_at = Date.today
        end

        attr_reader :search_request

        def build_entity
            PortfolioAdvisor::Entity::Rank.new(
                updated_at: update_at,
                rank: ranking
            )
        end

        def ranking
           # sorting first 
            sort_hash = @search_request.sort_by {|k,v| v}.reverse.to_h
            ranks = []
            sort_hash.each do |target, click_rate|
                ranks.push(target)
            end
            ranks = ranks.first(3).join(',')    
        end
        def update_at
            @update_at
        end
    end
  end
end
