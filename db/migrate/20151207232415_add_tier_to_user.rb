class AddTierToUser < ActiveRecord::Migration
  def change
    add_column :users, :tier, :string, limit: 20
  end
end
