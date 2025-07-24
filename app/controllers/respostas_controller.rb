# Controlador responsável por processar e salvar respostas de formulários.
class RespostasController < ApplicationController
  before_action :require_login

  # Verifica se todas as questões obrigatórias foram respondidas.
  #
  # @param questoesobg [ActiveRecord::Relation] lista de questões obrigatórias
  # @return [Array<String>] textos das questões não respondidas
  def questoesObrig(questoesobg)
    missing_required = []
    questoesobg.each do |questao|
      response_content = params[:respostas]&.[](questao.id.to_s)
      if response_content.blank?
        missing_required << questao.texto
      end
    end
    return missing_required
  end

  # Checa se há questões obrigatórias em branco e renderiza o formulário se houver.
  #
  # @return [Boolean] true se faltam questões obrigatórias, false caso contrário
  # @note Renderiza 'formularios/show' com alerta se houver questões em branco
  def questoesObrigfal
    required_questions = @questoes.where(obrigatoria: true)
    missing_required = questoesObrig(required_questions)
    
    if missing_required.any?
      flash.now[:alert] = "Todos os campos obrigatórios devem ser preenchidos"
      render 'formularios/show'
      return true
    else
      return false
    end
  end

  # Cria uma avaliação pendente se ainda não existir.
  #
  # @param avaliacao [Avaliacao, nil]
  # @return [Avaliacao, false] a avaliação criada ou existente, ou false em caso de erro
  # @note Renderiza 'formularios/show' com alerta se o usuário não estiver na turma
  def criaAvaliacao(avaliacao)
    if avaliacao.nil?
      if current_user.turmas.include?(@formulario.turma)
        avaliacao = Avaliacao.create!(
          user: current_user,
          formulario: @formulario,
          status: :pendente
        )
        return avaliacao
      else
        flash.now[:alert] = "Você não está matriculado nesta turma."
        render 'formularios/show'
        return false
      end
    else
      return avaliacao
    end
  end

  # Cria ou atualiza as respostas do usuário para cada questão respondida.
  #
  # @param avaliacao [Avaliacao] avaliação associada às respostas
  # @return [void]
  def conteudoQuestoes(avaliacao)
    @questoes.each do |questao|
      response_content = params[:respostas]&.[](questao.id.to_s)
      if response_content.present?
        resposta_existente = Resposta.find_by(
          questao: questao,
          user: current_user,
          avaliacao: avaliacao
        )
        
        if resposta_existente
          resposta_existente.update!(conteudo: response_content)
        else
          Resposta.create!(
            questao: questao,
            user: current_user,
            avaliacao: avaliacao,
            conteudo: response_content
          )
        end
      end
    end
  end

  # Processa o envio da avaliação e salva as respostas.
  #
  # @return [void]
  # @note Pode redirecionar em vários pontos ou renderizar com erro
  def create
    @formulario = Formulario.find(params[:formulario_id])
    @questoes = @formulario.template.questoes.order(:id)
    
    if questoesObrigfal
      return
    end

    avaliacao = Avaliacao.find_by(user: current_user, formulario: @formulario)
    avaliacao = criaAvaliacao(avaliacao)
    return unless avaliacao

    if avaliacao.concluida?
      redirect_to minhas_avaliacoes_path, notice: "Esta avaliação já foi concluída."
      return
    end

    conteudoQuestoes(avaliacao)
    avaliacao.update!(status: :concluida)
    
    redirect_to minhas_avaliacoes_path, notice: 'Avaliação enviada com sucesso!'
  end

  private

  # Redireciona se o usuário não estiver logado.
  def require_login
    unless current_user
      redirect_to login_path, alert: 'Você precisa fazer login primeiro.'
    end
  end
end
