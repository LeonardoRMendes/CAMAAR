class CreateAvaliacaos < ActiveRecord::Migration[7.0]
  def change
    create_table :avaliacaos do |t|
      t.references :user, null: false, foreign_key: true
      t.references :formulario, null: false, foreign_key: true
      t.integer :status, default: 0
      
      t.timestamps
    end
    
    add_index :avaliacaos, [:user_id, :formulario_id], unique: true
  end
end
