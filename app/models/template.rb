class Template < ApplicationRecord
  has_many :questoes, class_name: 'Questao', dependent: :destroy
  has_many :formularios, dependent: :destroy
  
  validates :nome, presence: true
end
