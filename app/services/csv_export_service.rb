require 'csv'

class CsvExportService
  def initialize(formulario)
    @formulario = formulario
  end

  def generate
    CSV.generate(headers: true) do |csv|
      csv << ["Questão", "Resposta", "Votos"]

      @formulario.template.questoes.each do |questao|
        resultados = questao.aggregate_results_for_formulario(@formulario)
        if resultados.empty?
          csv << [questao.texto, "Sem respostas", 0]
        else
          resultados.each do |resposta, contagem|
            csv << [questao.texto, resposta, contagem]
          end
        end
      end
    end
  end
end
