class AddTipoAndOpcoesToQuestoes < ActiveRecord::Migration[7.1]
  def change
    add_column :questaos, :opcoes, :text
  end
end
