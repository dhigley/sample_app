# Listing 9.39: The migration to add a boolean admin attribute to users.
class AddAdminToUsers < ActiveRecord::Migration
  def change
    add_column :users, :admin, :boolean, default: false
  end
end
