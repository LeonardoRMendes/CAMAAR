class ChangeQuestaoReferenceFromFormularioToTemplate < ActiveRecord::Migration[7.0]
  def change
    add_reference :questaos, :template, foreign_key: true
    remove_reference :questaos, :formulario, foreign_key: true
  end
end
