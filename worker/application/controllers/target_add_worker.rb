# frozen_string_literal: true

require 'aws-sdk-sqs'
require 'yaml'

COMPANY_YAML = 'config/company.yml'
COMPANY_LIST = YAML.safe_load(File.read(COMPANY_YAML))

module PortfolioAdvisor
  # Scheduled worker to report on recent cloning operations
  class AddTargetWorker
    def initialize
      @config = AddTargetWorker.config
      @queue = PortfolioAdvisor::Messaging::Queue.new(
        @config.ADD_QUEUE_URL, @config
      )
    end

    def call
      puts "update target start"
      updateTarget
      puts "update rank start"
      @search_targets = Hash.new

      @queue.poll do |search_request_json|
        search_request = Representer::SearchRequest
          .new(OpenStruct.new)
          .from_json(search_request_json)

        ranking(search_request)
      end

      unless @search_targets.empty?
        popular = Service::Ranking.new.call(search_targets: @search_targets)
        puts popular
      end
    end

    
    def ranking(search_request)
      target = search_request.company_name
      if @search_targets.member?(target)
        @search_targets[target] += 1
      else
        @search_targets.store(target, 1)
      end
    end

    def updateTarget
      COMPANY_LIST[0].each do |index, target|
        #target_request = Forms::NewTarget.new.call(index)
        puts "#{index} start"
        target_add = Service::AddTarget.new.call(company_name: index)
        if target_add.failure?
            puts "#{index} add error"
        else
            puts "#{index} success"
        end
      end
    rescue StandardError
      updateTarget
    end

  end
end
