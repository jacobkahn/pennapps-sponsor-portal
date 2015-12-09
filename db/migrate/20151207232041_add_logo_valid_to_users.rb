class AddLogoValidToUsers < ActiveRecord::Migration
  def change
    add_column :users, :logo_valid, :boolean
  end
end
