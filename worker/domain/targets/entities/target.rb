# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'

require_relative 'article'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Target < Dry::Struct
      include Dry.Types

      attribute :company_name,           Strict::String
      attribute :articles,               Strict::Array.of(Article)
      attribute :updated_at,             Strict::Date
      attribute :market_price,           Strict::Float
      attribute :long_advice_price,      Strict::Float
      attribute :mid_advice_price,       Strict::Float
      attribute :short_advice_price,     Strict::Float
      attribute :long_term_advice,      Strict::String
      attribute :mid_term_advice,       Strict::String
      attribute :short_term_advice,     Strict::String

      def to_attr_hash
        to_hash.reject do |key, _|
          %i[articles market_price long_advice_price mid_advice_price short_advice_price].include? key
        end
      end

      def to_history_hash
        to_hash.reject do |key, _|
          %i[company_name articles long_term_advice mid_term_advice short_term_advice].include? key
        end
      end
    end
  end
end
