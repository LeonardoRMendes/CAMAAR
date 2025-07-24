class Turma < ApplicationRecord
  has_many :matriculas, dependent: :destroy
  has_many :users, through: :matriculas
  has_many :formularios, dependent: :destroy
  
  validates :nome, presence: true
end
