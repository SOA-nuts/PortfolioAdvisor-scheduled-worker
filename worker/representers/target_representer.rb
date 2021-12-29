# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

require_relative 'article_representer'

# Represents essential Repo information for API output
module PortfolioAdvisor
  module Representer
    # Represent a target entity as Json
    class Target < Roar::Decorator
      include Roar::JSON
      include Roar::Hypermedia
      include Roar::Decorator::HypermediaConsumer

      property :company_name
      property :updated_at
      property :score
      collection :articles, extend: Representer::Article, class: OpenStruct

      link :self do
        "#{App.config.API_HOST}/api/v1/history/#{company_name}"
      end

      def company_name
        represented.company_name
      end
    end
  end
end
