class Formulario < ApplicationRecord
  belongs_to :turma
  belongs_to :template
  has_many :questoes, through: :template
  has_many :avaliacoes, class_name: 'Avaliacao', dependent: :destroy
  has_many :users, through: :avaliacoes
  
  validates :nome, presence: true
end
