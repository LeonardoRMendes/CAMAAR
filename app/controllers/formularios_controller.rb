# Controlador responsável por exibir os formulários disponíveis para o usuário.
class FormulariosController < ApplicationController
  before_action :require_login

  # Exibe um formulário específico e suas questões para o usuário atual.
  #
  # @return [void]
  # @note Este método:
  #   - Busca o formulário com o ID fornecido em `params[:id]`
  #   - Carrega as questões do template associado, ordenadas por ID
  #   - Busca a avaliação correspondente do usuário atual para esse formulário
  def show
    @formulario = Formulario.find(params[:id])
    @questoes = @formulario.template.questoes.order(:id)
    @avaliacao = Avaliacao.find_by(user: current_user, formulario: @formulario)
  end

  private

  # Garante que o usuário esteja logado antes de acessar as ações deste controller.
  #
  # @return [void]
  # @note Redireciona para a página de login se não houver usuário autenticado.
  def require_login
    unless current_user
      redirect_to login_path, alert: 'Você precisa fazer login primeiro.'
    end
  end
end
