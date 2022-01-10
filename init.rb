# frozen_string_literal: true

%w[config worker].each do |folder|
  require_relative "#{folder}/init"
end
