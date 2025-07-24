# Controlador responsável por exibir e exportar os resultados das avaliações dos formulários.
class Admin::ResultadosController < ApplicationController
  before_action :require_admin
  before_action :set_formulario, only: [:show, :export_csv]

  # Lista todos os formulários disponíveis para visualização de resultados.
  #
  # @return [void]
  def index
    @formularios = Formulario.includes(:template, :turma).all
  end

  # Exibe os resultados agregados de um formulário.
  #
  # @return [void]
  # @note Define a flag @sem_respostas se nenhuma avaliação foi concluída.
  #       Caso contrário, agrega os resultados das questões usando o método da model Questao.
  def show
    @resultados_agregados = {}

    if @formulario.avaliacoes.where(status: :concluida).none?
      @sem_respostas = true
    else
      @formulario.template.questoes.each do |questao|
        @resultados_agregados[questao] = questao.aggregate_results_for_formulario(@formulario)
      end
    end
  end

  # Exporta os resultados do formulário atual em formato CSV.
  #
  # @return [void]
  # @note Usa o serviço CsvExportService. Em caso de erro, redireciona de volta com alerta.
  def export_csv
    begin
      csv_data = CsvExportService.new(@formulario).generate
      send_data csv_data,
                filename: "#{@formulario.nome.parameterize}_resultados.csv",
                type: 'text/csv'
    rescue StandardError => e
      Rails.logger.error "Erro ao exportar CSV: #{e.message}"
      redirect_to admin_resultado_path(@formulario),
                  alert: 'Não foi possível gerar o arquivo de resultados.'
    end
  end

  private

  # Garante que apenas administradores possam acessar este controller.
  #
  # @return [void]
  def require_admin
    redirect_to root_path unless current_user&.admin?
  end

  # Define o formulário a partir do ID fornecido na rota.
  #
  # @return [void]
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end
