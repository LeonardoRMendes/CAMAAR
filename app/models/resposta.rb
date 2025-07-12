class Resposta < ApplicationRecord
  belongs_to :questao
  belongs_to :user
  belongs_to :avaliacao
  
  validates :conteudo, presence: true
  validates :user_id, uniqueness: { scope: :questao_id }
end
