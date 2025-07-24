class User < ApplicationRecord
  has_secure_password validations: false
  
  has_many :matriculas, dependent: :destroy
  has_many :turmas, through: :matriculas
  has_many :respostas, dependent: :destroy
  has_many :avaliacoes, class_name: 'Avaliacao', dependent: :destroy
  has_many :formularios, through: :avaliacoes
  
  enum :role, { participante: 0, admin: 1 }
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true, allow_blank: true
  validates :password, confirmation: true, allow_nil: true, allow_blank: true
  
  # Campo para reset de senha
  attr_accessor :password_reset_token
  
  def password_set?
    password_digest.present?
  end
end
