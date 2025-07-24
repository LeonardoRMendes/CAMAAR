class Admin::ImportacoesController < ApplicationController
  before_action :require_admin

  def index
  end

  def importSucess(result)
    stats = result[:stats]
      if stats[:turmas] == 0 && stats[:discentes] == 0
        flash[:notice] = "#{stats[:discentes]} novos participantes e #{stats[:turmas]} novas turmas foram adicionados"
      else
        flash[:notice] = "Arquivo importado com sucesso! " \
                        "#{stats[:turmas]} turmas, " \
                        "#{stats[:discentes]} discentes, " \
                        "#{stats[:matriculas]} matrículas criadas."
      end
  end

  def importFailure(result)
    if result[:error] == 'JSON inválido'
        flash[:alert] = "Ocorreu um erro ao processar o arquivo. Verifique o formato do JSON."
    else
        flash[:alert] = result[:error]
    end
  end

  def importResult(result)
    if result[:success]
      importSucess(result)
    else
      importFailure(result)
    end
  end

  def create
    if params[:arquivo].present?
      result = Import::FromJsonFile.new(params[:arquivo]).call
      importResult(result)
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
