class UpdateUserContraints < ActiveRecord::Migration
  def up
  	change_column(:users, :name, :string, null: false, default: "")
  	change_column(:users, :email, :string, null: false, default: "")
  	change_column(:users, :title, :string, default: "")
  end
  def down
  	change_column(:users, :name, :string, null: false, default: "")
  	change_column(:users, :email, :string, null: false, default: "")
  	change_column(:users, :title, :string, default: "")
  end
end