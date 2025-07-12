class RespostasController < ApplicationController
  before_action :require_login
  
  def create
    @formulario = Formulario.find(params[:formulario_id])
    @questoes = @formulario.questoes.order(:id)
    
    required_questions = @questoes.where(obrigatoria: true)
    missing_required = []
    
    required_questions.each do |questao|
      response_content = params[:respostas]&.[](questao.id.to_s)
      if response_content.blank?
        missing_required << questao.texto
      end
    end
    
    if missing_required.any?
      flash.now[:alert] = "Todos os campos obrigatórios devem ser preenchidos"
      render 'formularios/show'
      return
    end
    
    @questoes.each do |questao|
      response_content = params[:respostas]&.[](questao.id.to_s)
      if response_content.present?
        Resposta.create!(
          questao: questao,
          user: current_user,
          conteudo: response_content
        )
      end
    end
    
    avaliacao = Avaliacao.find_by(user: current_user, formulario: @formulario)
    avaliacao&.update!(status: :concluida)
    
    redirect_to minhas_avaliacoes_path, notice: 'Avaliação enviada com sucesso!'
  end
  
  private
  
  def require_login
    unless current_user
      redirect_to login_path, alert: 'Você precisa fazer login primeiro.'
    end
  end
end
