require 'csv'

class CsvExportService
  def initialize(formulario)
    @formulario = formulario
  end

  # Gera um arquivo CSV contendo os resultados agregados das questões do formulário.
  #
  # @return [String] uma string CSV com cabeçalhos e contagens por resposta
  # @note Para cada questão, insere a resposta e o número de votos. Se não houver respostas, inclui "Sem respostas".
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
