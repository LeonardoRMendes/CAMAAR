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

  # Agrupa e conta as respostas dadas para esta questão em um determinado formulário.
  #
  # @param formulario [Formulario] o formulário cujos resultados devem ser agregados
  # @return [Hash{String => Integer}] um hash com o conteúdo das respostas como chave e a quantidade como valor
  # @note Considera apenas avaliações com status concluído.
  def aggregate_results_for_formulario(formulario)
    respostas = Resposta.joins(:avaliacao)
                       .where(questao: self, avaliacaos: { formulario_id: formulario.id, status: :concluida })
                       .pluck(:conteudo)
    
    respostas.group_by(&:itself).transform_values(&:count)
  end

  # Retorna a lista de opções disponíveis para a questão.
  #
  # @return [Array<String>] as opções disponíveis para múltipla escolha, ou uma lista padrão se estiver vazia
  # @note Retorna lista vazia se a questão for do tipo texto.
  def opcoes_lista
    return [] if texto?
    return opcoes if opcoes.is_a?(Array) && opcoes.any?
    OPCOES_AVALIACAO
  end
end
