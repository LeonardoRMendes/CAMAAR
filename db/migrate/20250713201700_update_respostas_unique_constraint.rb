class UpdateRespostasUniqueConstraint < ActiveRecord::Migration[8.0]
  def up
    # Remover o índice único existente (user_id, questao_id)
    remove_index :respostas, [:user_id, :questao_id] if index_exists?(:respostas, [:user_id, :questao_id])
    
    # Adicionar novo índice único incluindo avaliacao_id
    add_index :respostas, [:user_id, :questao_id, :avaliacao_id], unique: true, name: 'index_respostas_on_user_questao_avaliacao'
  end

  def down
    # Reverter: remover o novo índice
    remove_index :respostas, name: 'index_respostas_on_user_questao_avaliacao' if index_exists?(:respostas, name: 'index_respostas_on_user_questao_avaliacao')
    
    # Restaurar o índice antigo
    add_index :respostas, [:user_id, :questao_id], unique: true
  end
end
