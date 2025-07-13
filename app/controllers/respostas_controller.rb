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

    avaliacao = Avaliacao.find_by(user: current_user, formulario: @formulario)
    
    if avaliacao.nil?
      flash.now[:alert] = "Avaliação não encontrada para este usuário."
      render 'formularios/show'
      return
    end
    
    # Verificar se a avaliação já foi concluída
    if avaliacao.concluida?
      redirect_to minhas_avaliacoes_path, notice: "Esta avaliação já foi concluída."
      return
    end

    @questoes.each do |questao|
      response_content = params[:respostas]&.[](questao.id.to_s)
      if response_content.present?
        # Verificar se a resposta já existe para esta avaliação específica
        resposta_existente = Resposta.find_by(
          questao: questao,
          user: current_user,
          avaliacao: avaliacao
        )
        
        if resposta_existente
          # Atualizar resposta existente
          resposta_existente.update!(
            conteudo: response_content
          )
        else
          # Criar nova resposta
          Resposta.create!(
            questao: questao,
            user: current_user,
            avaliacao: avaliacao,
            conteudo: response_content
          )
        end
      end
    end

    avaliacao.update!(status: :concluida)
    
    redirect_to minhas_avaliacoes_path, notice: 'Avaliação enviada com sucesso!'
  end
  
  private
  
  def require_login
    unless current_user
      redirect_to login_path, alert: 'Você precisa fazer login primeiro.'
    end
  end
end
