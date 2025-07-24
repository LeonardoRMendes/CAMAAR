# Controlador responsável por exibir as avaliações pendentes do usuário logado.
class AvaliacoesController < ApplicationController
  before_action :require_login

  # Lista as avaliações pendentes do usuário atual e agrupa por turma.
  #
  # @return [void]
  # @note Os dados são atribuídos às variáveis de instância:
  #   - @avaliacoes_pendentes: todas as avaliações com status :pendente
  #   - @turmas_com_avaliacoes: hash com as avaliações agrupadas por turma
  def index
    @avaliacoes_pendentes = current_user.avaliacoes.includes(formulario: [:turma, :template]).where(status: :pendente)
    @turmas_com_avaliacoes = @avaliacoes_pendentes.group_by { |avaliacao| avaliacao.formulario.turma }
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
