class AddAvaliacaoToRespostas < ActiveRecord::Migration[7.0]
  def change
    add_reference :respostas, :avaliacao, null: false, foreign_key: true
  end
end
