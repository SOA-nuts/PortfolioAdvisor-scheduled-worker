# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:articles) do
      primary_key :id
      foreign_key :company_id, :targets

      String      :title, null: false
      String      :url, unique: true

      DateTime    :published_at
      Integer     :score
    end
  end
end
