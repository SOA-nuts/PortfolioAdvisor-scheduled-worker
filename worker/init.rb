# frozen_string_literal: true

%w[domain infrastructure representers application].each do |folder|
  require_relative "#{folder}/init"
end
