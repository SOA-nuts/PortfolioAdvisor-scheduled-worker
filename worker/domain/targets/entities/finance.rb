# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Finance < Dry::Struct
      include Dry.Types

      attribute :bench_price,       Strict::Float
      attribute :grow_score,        Strict::Float
      attribute :market_price,      Strict::Float
    end
  end
end
