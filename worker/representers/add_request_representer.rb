# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

# Represents essential Repo information for API output
module PortfolioAdvisor
  module Representer
    # Representer object for target clone requests
    class SearchRequest < Roar::Decorator
      include Roar::JSON

      property :company_name
      property :id
    end
  end
end
