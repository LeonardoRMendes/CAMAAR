class Questao < ApplicationRecord
  belongs_to :template
  
  enum :tipo, { texto: 'texto', multipla_escolha: 'multipla_escolha' }
  
  validates :texto, presence: true
  validates :obrigatoria, inclusion: { in: [true, false] }
  validates :tipo, presence: true
  validates :opcoes, presence: true, if: :multipla_escolha?
  
  serialize :opcoes, coder: JSON
  
  OPCOES_AVALIACAO = [
    "Muito bom",
    "Bom", 
    "Normal",
    "Ruim",
    "Muito ruim"
  ].freeze

  def aggregate_results_for_formulario(formulario)
    respostas = Resposta.joins(:avaliacao)
                       .where(questao: self, avaliacaos: { formulario_id: formulario.id, status: :concluida })
                       .pluck(:conteudo)
    
    respostas.group_by(&:itself).transform_values(&:count)
  end
  
  def opcoes_lista
    return [] if texto?
    return opcoes if opcoes.is_a?(Array) && opcoes.any?
    OPCOES_AVALIACAO
  end
end
