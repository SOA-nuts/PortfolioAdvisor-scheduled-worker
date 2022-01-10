# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:ranks) do
      primary_key :id

      String      :rank, null: false
      DateTime    :updated_at, null: false
    end
  end
end
