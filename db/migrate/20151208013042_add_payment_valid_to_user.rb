class AddPaymentValidToUser < ActiveRecord::Migration
  def change
    add_column :users, :payment_received, :boolean, default: false
  end
end
