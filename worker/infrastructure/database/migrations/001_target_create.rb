# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:targets) do
      primary_key :id
      String      :company_name, unique: true
      Date        :updated_at

      String      :long_term_advice
      String      :mid_term_advice
      String      :short_term_advice
    end
  end
end
