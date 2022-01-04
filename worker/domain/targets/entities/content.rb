# frozen_string_literal: true

require 'dry-types'
require 'dry-struct'
require 'date'
require 'textmood'

module PortfolioAdvisor
  module Entity
    # Domain entity for any article
    class Content
      def initialize(content)
        @content = content
      end

      def score
        tm = TextMood.new(language: 'en', normalize_score: true)
        tm.analyze(@content).to_i
      end
    end
  end
end
