# frozen_string_literal: true

require 'dry/transaction'

module PortfolioAdvisor
  module Service
    # Transaction to store target from GoogleNews API to database
    class AddTarget
      include Dry::Transaction

      step :check_target_status
      step :store_target

      private

      DB_ERR_MSG = 'Having trouble accessing the database'
      NOT_SUPPORT_MSG = 'this compnay is not on our supporting list'
      GN_NOT_FOUND_MSG = 'Could not find related articles of the compnay on Google News'
      SYMBOL_NOT_FOUND_MSG = 'Could not find symbol'

      def check_target_status(input)
        input[:symbol] = COMPANY_LIST[0][input[:company_name]]
        Failure(Response::ApiResult.new(status: :not_found, message: SYMBOL_NOT_FOUND_MSG)) if input[:symbol].nil?

        if (target = target_in_database(input))
          # update = true
          if target.updated_at != Date.today
            input[:update_target] = target_from_news(input, true)
          else
            input[:local_target] = target
          end
        else
          # update = false, need create
          input[:remote_target] = target_from_news(input, false)
        end
        Success(input)
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :not_found, message: GN_NOT_FOUND_MSG))
      end

      def store_target(input)
        target =
          if (new_target = input[:remote_target])
            Repository::For.entity(new_target).create(new_target)
          elsif (update_target = input[:update_target])
            puts 'update database'
            Repository::For.entity(update_target).update(update_target)
          else
            input[:local_target]
          end
        Success(Response::ApiResult.new(status: :created, message: target))
      rescue StandardError => e
        print_error(e)
        Failure(Response::ApiResult.new(status: :not_found, message: DB_ERR_MSG))
      end

      def target_in_database(input)
        Repository::Targets.find_company(input[:company_name])
      end

      def target_from_news(input, update)
        if update
          GoogleNews::TargetMapper.new(AddTargetWorker.config.GOOGLENEWS_TOKEN).find(input[:company_name],
                                                                                     input[:symbol], Date.today)
        else
          GoogleNews::TargetMapper.new(AddTargetWorker.config.GOOGLENEWS_TOKEN).find(input[:company_name],
                                                                                     input[:symbol], nil)
        end
      rescue StandardError => e
        print_error(e)
        raise GN_NOT_FOUND_MSG
      end

      def print_error(error)
        puts [error.inspect, error.backtrace].flatten.join("\n")
      end
    end
  end
end
