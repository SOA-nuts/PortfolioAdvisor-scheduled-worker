# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Transaction to store target from GoogleNews API to database
    class AddTarget
      include Dry::Transaction

      step :validate_input
      step :request_target
      step :reify_target

      private

      def validate_input(input)
          company_name = input
          Success(company_name: company_name)
      end

      def request_target(input)
        result = Gateway::Api.new(PortfolioAdvisor::AddTargetWorker.config)
          .add_target(input[:company_name])
        result.success? ? Success(result.payload) : Failure(result.message)
      rescue StandardError => error
        puts [error.inspect, error.backtrace].flatten.join("\n")
        Failure('Cannot add target right now; please try again later')
      end

      def reify_target(target_json)
        Representer::Target.new(OpenStruct.new)
          .from_json(target_json)
          .then do |target|
          Success(target)
        end
      rescue StandardError => error
        puts [error.inspect, error.backtrace].flatten.join("\n")
        Failure('Error in add target -- please try again')
      end
    end
  end
end
