# frozen_string_literal: true

require_relative '../../init.rb'
require 'aws-sdk-sqs'
require 'yaml'

COMPANY_YAML = 'config/company.yml'
COMPANY_LIST = YAML.safe_load(File.read(COMPANY_YAML))

module PortfolioAdvisor
  # Scheduled worker to report on recent cloning operations
  class AddTargetWorker
    def initialize
      @config = AddTargetWorker.config
    end

    def call
      # POST /target/
      COMPANY_LIST[0].each do |index, target|
        #target_request = Forms::NewTarget.new.call(index)
        target_add = Service::AddTarget.new.call(index)
        puts target_add
        if target_add.failure?
            puts "target add error"
        else
            puts "target_add success"
        end
      end
    end
  end
end
