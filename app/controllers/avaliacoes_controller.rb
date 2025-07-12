class AvaliacoesController < ApplicationController
  before_action :require_login
  
  def index
    @avaliacoes_pendentes = current_user.avaliacoes.includes(formulario: [:turma, :template]).where(status: :pendente)
    @turmas_com_avaliacoes = @avaliacoes_pendentes.group_by { |avaliacao| avaliacao.formulario.turma }
  end
  
  private
  
  def require_login
    unless current_user
      redirect_to login_path, alert: 'Você precisa fazer login primeiro.'
    end
  end
end
