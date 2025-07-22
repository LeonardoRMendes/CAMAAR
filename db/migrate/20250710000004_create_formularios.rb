class CreateFormularios < ActiveRecord::Migration[7.0]
  def change
    create_table :formularios do |t|
      t.string :nome, null: false
      t.text :descricao
      t.boolean :ativo, default: true
      t.references :turma, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
