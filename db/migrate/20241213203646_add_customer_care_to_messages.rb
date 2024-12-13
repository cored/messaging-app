class AddCustomerCareToMessages < ActiveRecord::Migration[7.0]
  def change
    add_column :messages, :customer_care_id, :integer
  end
end
