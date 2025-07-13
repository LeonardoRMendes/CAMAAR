class Admin::ResultadosController < ApplicationController
  before_action :require_admin
  before_action :set_formulario, only: [:show, :export_csv]

  def index
    @formularios = Formulario.includes(:template, :turma).all
  end

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

  def export_csv
    begin
      csv_data = CsvExportService.new(@formulario).generate
      send_data csv_data, filename: "#{@formulario.nome.parameterize}_resultados.csv", type: 'text/csv'
    rescue StandardError => e
      Rails.logger.error "Erro ao exportar CSV: #{e.message}"
      redirect_to admin_resultado_path(@formulario), alert: 'Não foi possível gerar o arquivo de resultados.'
    end
  end

  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end

  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
end
