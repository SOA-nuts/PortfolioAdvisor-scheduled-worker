# frozen_string_literal: true

folders = %w[responses service controllers]
folders.each do |folder|
  require_relative "#{folder}/init.rb"
end
