# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Rank < Dry::Struct
      include Dry.Types

      attribute :rank,              Strict::String
      attribute :updated_at,        Strict::Date

      def to_rank_hash
        to_hash.reject { |key, _| %i[rank updated_at].include? key }
      end
    end
  end
end
