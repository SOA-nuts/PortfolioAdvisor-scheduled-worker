# frozen_string_literal: true

require 'roar/decorator'
require 'roar/json'

module PortfolioAdvisor
  module Representer
    class Article < Roar::Decorator
      include Roar::JSON

      property :title
      property :url
      property :published_at
      property :score
    end
  end
end
