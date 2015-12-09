class AddPrimaryContactNameAndPrimaryContactEmailToUser < ActiveRecord::Migration
  def change
    add_column :users, :primary_contact_name, :string
    add_column :users, :primary_contact_email, :string
  end
end
