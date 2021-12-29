# frozen_string_literal: true

require 'dry-validation'

module PortfolioAdvisor
  module Forms
    class NewTarget < Dry::Validation::Contract
      params do
        required(:company_name).filled(:string)
      end
    end
  end
end
