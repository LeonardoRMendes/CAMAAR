class CreateTemplates < ActiveRecord::Migration[7.0]
  def change
    create_table :templates do |t|
      t.string :nome, null: false
      t.text :descricao
      
      t.timestamps
    end
  end
end
