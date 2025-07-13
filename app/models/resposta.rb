class Resposta < ApplicationRecord
  self.table_name = 'respostas'
  
  belongs_to :questao
  belongs_to :user
  belongs_to :avaliacao
  
  validates :conteudo, presence: true
  validates :user_id, uniqueness: { scope: [:questao_id, :avaliacao_id] }
end
