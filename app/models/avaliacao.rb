# Representa a avaliação que um usuário deve realizar para um formulário específico.
#
# Cada avaliação pertence a um usuário e a um formulário, e possui um status
# (pendente ou concluída).
#
# Restrições:
# - Um mesmo usuário só pode ter uma avaliação por formulário.
#
# Efeitos colaterais:
# - Ao excluir uma avaliação, todas as suas respostas são automaticamente excluídas.
class Avaliacao < ApplicationRecord
  # Associa a avaliação a um usuário.
  #
  # @return [User]
  belongs_to :user

  # Associa a avaliação a um formulário.
  #
  # @return [Formulario]
  belongs_to :formulario

  # Lista de respostas dadas nesta avaliação.
  #
  # @return [Array<Resposta>]
  # @note Todas as respostas são destruídas junto com a avaliação.
  has_many :respostas, dependent: :destroy, class_name: 'Resposta'

  # Status da avaliação.
  #
  # @return [Symbol] :pendente ou :concluida
  enum :status, { pendente: 0, concluida: 1 }

  # Garante que um usuário não possa ter mais de uma avaliação para o mesmo formulário.
  validates :user_id, uniqueness: { scope: :formulario_id }
end
