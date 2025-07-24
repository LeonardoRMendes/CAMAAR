class Avaliacao < ApplicationRecord
  belongs_to :user
  belongs_to :formulario
  has_many :respostas, dependent: :destroy, class_name: 'Resposta'
  
  enum :status, { pendente: 0, concluida: 1 }
  
  validates :user_id, uniqueness: { scope: :formulario_id }
end
