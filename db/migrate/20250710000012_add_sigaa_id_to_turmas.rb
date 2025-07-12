class AddSigaaIdToTurmas < ActiveRecord::Migration[7.0]
  def change
    add_column :turmas, :sigaa_id, :string
    add_column :turmas, :ano, :integer
    add_column :turmas, :periodo, :integer
    add_index :turmas, :sigaa_id, unique: true
  end
end
