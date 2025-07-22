class AddTemplateToFormularios < ActiveRecord::Migration[7.0]
  def change
    add_reference :formularios, :template, foreign_key: true
  end
end
