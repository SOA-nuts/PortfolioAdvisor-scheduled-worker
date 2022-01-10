# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Transaction to store target from GoogleNews API to database
    class Ranking
      include Dry::Transaction

      step :create_ranking
      step :store_ranking

      private

      CREATE_ERR = 'Having trouble create rank'
      STORE_ERR = 'Having trouble store rank'

      def create_ranking(input)
        input[:ranking] = Mapper::Rank.new(input[:search_targets]).build_entity
        Success(input)
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :internal_error, message: CREATE_ERR))
      end

      def store_ranking(input)
        rank = Repository::Rank.db_find_or_create(input[:ranking])
        Success(Response::ApiResult.new(status: :created, message: rank))
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :internal_error, message: STORE_ERR))
      end

      def print_error(error)
        puts [error.inspect, error.backtrace].flatten.join("\n")
      end
    end
  end
end
