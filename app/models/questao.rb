class Questao < ApplicationRecord
  belongs_to :template
  
  validates :texto, presence: true
  validates :obrigatoria, inclusion: { in: [true, false] }

  def aggregate_results_for_formulario(formulario)
    {}
  end
end
