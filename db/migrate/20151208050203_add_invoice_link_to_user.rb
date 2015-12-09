class AddInvoiceLinkToUser < ActiveRecord::Migration
  def change
    add_column :users, :invoice_link, :string
  end
end
