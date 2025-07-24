class CreateTurmas < ActiveRecord::Migration[7.0]
  def change
    create_table :turmas do |t|
      t.string :nome, null: false
      t.string :codigo, null: false
      t.text :descricao
      
      t.timestamps
    end
    
    add_index :turmas, :codigo, unique: true
  end
end
