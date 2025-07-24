class CreateMatriculas < ActiveRecord::Migration[7.0]
  def change
    create_table :matriculas do |t|
      t.references :user, null: false, foreign_key: true
      t.references :turma, null: false, foreign_key: true
      
      t.timestamps
    end
    
    add_index :matriculas, [:user_id, :turma_id], unique: true
  end
end
