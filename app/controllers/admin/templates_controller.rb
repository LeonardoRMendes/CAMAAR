# Controlador responsável por criar, editar e excluir templates de avaliação.
class Admin::TemplatesController < ApplicationController
  before_action :require_admin
  before_action :set_template, only: [:edit, :update, :destroy]

  # Lista todos os templates cadastrados.
  #
  # @return [void]
  def index
    @templates = Template.all
  end

  # Exibe o formulário de criação de um novo template.
  #
  # @return [void]
  def new
    @template = Template.new
    @template.questoes.build
  end

  # Verifica se o template preenchido no formulário é válido.
  #
  # @return [Boolean, nil] retorna true se inválido (e interrompe o fluxo), nil caso contrário.
  # @note Define mensagens de erro via flash e renderiza a view :new se necessário.
  def templateValido?
    if @template.nome.blank?
      flash.now[:alert] = "O template deve ter um nome"
      render :new
      return true
    end

    if params[:questoes].blank? || params[:questoes].all? { |q| q[:texto].blank? }
      flash.now[:alert] = "O template deve ter pelo menos uma questão"
      render :new
      return true
    end
  end

  # Cria uma nova questão associada ao template.
  #
  # @param questao [Hash] os dados da questão fornecidos no formulário
  # @return [void]
  def criarQuestao(questao)
    opcoes = nil
    if questao[:tipo] == 'multipla_escolha' && questao[:opcoes_texto].present?
      opcoes = questao[:opcoes_texto].split("\n").map(&:strip).reject(&:blank?)
    end
    @template.questoes.create!(
      texto: questao[:texto],
      obrigatoria: questao[:obrigatoria] == '1',
      tipo: questao[:tipo] || 'texto',
      opcoes: opcoes
    )
  end

  # Cria um novo template com suas questões.
  #
  # @return [void]
  # @note Redireciona para o index com mensagem de sucesso, ou renderiza :new em caso de erro.
  def create
    @template = Template.new(template_params)

    if templateValido?
      return
    end

    @template.save!
    params[:questoes].each do |questao_params|
      next if questao_params[:texto].blank?
      criarQuestao(questao_params)
    end

    redirect_to admin_templates_path, notice: "Template '#{@template.nome}' criado com sucesso"
  end

  # Exibe o formulário de edição do template.
  #
  # @return [void]
  def edit
  end

  # Atualiza as questões já existentes no template.
  #
  # @param questao [Hash] parâmetros das questões existentes
  # @return [void]
  def updateQuestoesExis(questao)
    if questao
      questao.each do |id, questao_params|
        questao = @template.questoes.find(id)

        opcoes = nil
        if questao_params[:tipo] == 'multipla_escolha' && questao_params[:opcoes]
          opcoes = questao_params[:opcoes].reject(&:blank?)
        end

        questao.update(
          texto: questao_params[:texto],
          obrigatoria: questao_params[:obrigatoria] == '1',
          tipo: questao_params[:tipo] || 'texto',
          opcoes: opcoes
        )
      end
    end
  end

  # Adiciona novas questões ao template durante a edição.
  #
  # @param questao [Hash] parâmetros das novas questões
  # @return [void]
  def updateQuestoesNovas(questao)
    if questao
      questao.each do |index, questao_params|
        next if questao_params[:texto].blank?

        opcoes = nil
        if questao_params[:tipo] == 'multipla_escolha' && questao_params[:opcoes]
          opcoes = questao_params[:opcoes].reject(&:blank?)
        end

        @template.questoes.create!(
          texto: questao_params[:texto],
          obrigatoria: questao_params[:obrigatoria] == '1',
          tipo: questao_params[:tipo] || 'texto',
          opcoes: opcoes
        )
      end
    end
  end

  # Remove questões marcadas para exclusão durante a edição.
  #
  # @param questaoR [Array<String>] IDs das questões a serem removidas
  # @return [void]
  def removerQuestoes(questaoR)
    if questaoR
      questaoR.each do |id|
        next if id.blank?
        questao = @template.questoes.find(id)
        questao.destroy
      end
    end
  end

  # Verifica se o nome do template está presente durante a atualização.
  #
  # @return [Boolean, nil] true se inválido (e interrompe), nil caso contrário.
  def nomeValidoupdate
    if @template.nome.blank?
      flash.now[:alert] = "O template deve ter um nome"
      render :edit
      return true
    end
  end

  # Atualiza o template e suas questões associadas.
  #
  # @return [void]
  def update
    if nomeValidoupdate
      return
    end

    updateQuestoesExis(params[:questoes_existentes])
    updateQuestoesNovas(params[:questoes_novas])
    removerQuestoes(params[:questoes_remover])

    if @template.update(template_params)
      redirect_to admin_templates_path, notice: "Template '#{@template.nome}' atualizado com sucesso"
    else
      render :edit
    end
  end

  # Exclui um template, se ele não estiver associado a nenhum formulário.
  #
  # @return [void]
  def destroy
    if @template.formularios.exists?
      redirect_to admin_templates_path,
                  alert: "Não é possível excluir o template '#{@template.nome}', pois ele já foi utilizado em formulários."
      return
    end

    template_nome = @template.nome
    @template.destroy
    redirect_to admin_templates_path, notice: "Template '#{template_nome}' foi excluído com sucesso."
  end

  private

  # Define a instância de template a partir do ID da rota.
  #
  # @return [void]
  def set_template
    @template = Template.find(params[:id])
  end

  # Define os parâmetros permitidos para criação/atualização de templates.
  #
  # @return [ActionController::Parameters] os parâmetros permitidos
  def template_params
    params.require(:template).permit(:nome, :descricao)
  end

  # Garante que o usuário atual seja administrador.
  #
  # @return [void]
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Acesso negado.'
    end
  end
end
