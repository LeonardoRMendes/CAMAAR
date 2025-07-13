class CreateRespostas < ActiveRecord::Migration[7.0]
  def change
    create_table :respostas do |t|
      t.text :conteudo, null: false
      t.references :questao, null: false, foreign_key: true
      t.references :user, null: false, foreign_key: true
      
      t.timestamps
    end
    
    add_index :respostas, [:user_id, :questao_id], unique: true
  end
end
