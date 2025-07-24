class AddFieldsToUsers < ActiveRecord::Migration[7.0]
  def change
    add_column :users, :nome, :string
    add_column :users, :matricula, :string
    add_index :users, :matricula, unique: true
  end
end
