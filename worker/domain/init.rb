# frozen_string_literal: true

folders = %w[targets]
folders.each do |folder|
  require_relative "#{folder}/init"
end
