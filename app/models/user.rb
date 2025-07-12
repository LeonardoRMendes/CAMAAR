class User < ApplicationRecord
  has_secure_password validations: false
  
  has_many :matriculas, dependent: :destroy
  has_many :turmas, through: :matriculas
  has_many :respostas, dependent: :destroy
  has_many :avaliacoes, dependent: :destroy
  has_many :formularios, through: :avaliacoes
  
  enum role: { participante: 0, admin: 1 }
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, if: :password_digest_changed?
  validates :password, confirmation: true, if: :password_digest_changed?
  
  def password_set?
    password_digest.present?
  end
end
