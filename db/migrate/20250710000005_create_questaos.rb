class CreateQuestaos < ActiveRecord::Migration[7.0]
  def change
    create_table :questaos do |t|
      t.string :texto, null: false
      t.string :tipo, default: 'text'
      t.boolean :obrigatoria, default: false
      t.references :formulario, null: false, foreign_key: true
      
      t.timestamps
    end
  end
end
