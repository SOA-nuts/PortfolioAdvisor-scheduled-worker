# frozen_string_literal: true

require 'sequel'

Sequel.migration do
  change do
    create_table(:targets) do
      primary_key :id
      String      :company_name, unique: true
      Date        :updated_at
      Float       :market_price
      Float       :long_advice_price
      Float       :mid_advice_price
      Float       :short_advice_price
    end
  end
end
