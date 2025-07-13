class Admin::ImportacoesController < ApplicationController
  before_action :require_admin

  def index
  end

  def create
    if params[:arquivo].present?
      result = Import::FromJsonFile.new(params[:arquivo]).call
      
      if result[:success]
        stats = result[:stats]
        flash[:notice] = "Arquivo importado com sucesso! " \
                        "#{stats[:turmas]} turmas, " \
                        "#{stats[:discentes]} discentes, " \
                        "#{stats[:matriculas]} matrículas criadas."
      else
        flash[:alert] = result[:error]
      end
    else
      flash[:alert] = "Por favor, selecione um arquivo para importar."
    end
    
    redirect_to admin_importacoes_path
  end

  private

  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
