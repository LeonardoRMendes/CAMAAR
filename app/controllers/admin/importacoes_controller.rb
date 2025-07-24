# Controlador responsável por importar dados de turmas e participantes a partir de um arquivo JSON.
class Admin::ImportacoesController < ApplicationController
  before_action :require_admin

  # Exibe a tela de importação.
  #
  # @return [void]
  def index
  end

  # Define a mensagem de sucesso após a importação.
  #
  # @param result [Hash] o resultado da importação, contendo a chave :stats
  # @return [void]
  # @note Define flash[:notice] com resumo da operação realizada.
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

  # Define a mensagem de erro após falha na importação.
  #
  # @param result [Hash] o resultado da importação, contendo a chave :error
  # @return [void]
  # @note Define flash[:alert] com a descrição do erro.
  def importFailure(result)
    if result[:error] == 'JSON inválido'
      flash[:alert] = "Ocorreu um erro ao processar o arquivo. Verifique o formato do JSON."
    else
      flash[:alert] = result[:error]
    end
  end

  # Decide qual mensagem exibir com base no sucesso ou falha da importação.
  #
  # @param result [Hash] o resultado da importação, com as chaves :success, :stats ou :error
  # @return [void]
  # @note Chama `importSucess` ou `importFailure` dependendo do resultado.
  def importResult(result)
    if result[:success]
      importSucess(result)
    else
      importFailure(result)
    end
  end

  # Executa o processo de importação a partir do arquivo JSON enviado pelo usuário.
  #
  # @return [void]
  # @note Redireciona para a tela de importações com uma mensagem de sucesso ou erro.
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

  # Garante que o usuário seja um administrador.
  #
  # @return [void]
  # @note Redireciona para a página inicial se o usuário não for admin.
  def require_admin
    redirect_to root_path unless current_user&.admin?
  end
end
