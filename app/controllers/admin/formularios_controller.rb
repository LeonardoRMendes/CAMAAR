# Controlador responsável pelo gerenciamento de formulários de avaliação pelo administrador.
class Admin::FormulariosController < ApplicationController
  before_action :require_admin
  before_action :set_formulario, only: [:destroy]

  # Lista todos os formulários existentes com suas turmas e templates associados.
  #
  # @return [void]
  def index
    @formularios = Formulario.includes(:template, :turma).all
  end

  # Exibe o formulário para criação de novos formulários de avaliação.
  #
  # @return [void]
  def new
    @templates = Template.all
    @turmas = Turma.all
  end

  # Valida se o formulário pode ser criado com base nos parâmetros fornecidos.
  #
  # @param template_id [String] o ID do template selecionado
  # @param turma_ids [Array<String>] os IDs das turmas selecionadas
  # @return [Boolean, nil] retorna true se inválido (interrompe o fluxo); nil caso contrário
  # @note Renderiza a view `new` com mensagens de erro se houver problemas.
  def formularioValido(template_id, turma_ids)
    if template_id.blank?
      flash.now[:alert] = "É necessário selecionar um template."
      @templates = Template.all
      @turmas = Turma.all
      render :new
      return true
    end

    if turma_ids.empty?
      flash.now[:alert] = "É necessário selecionar pelo menos uma turma."
      @templates = Template.all
      @turmas = Turma.all
      render :new
      return true
    end
  end

  # Cria formulários e avaliações para as turmas selecionadas.
  #
  # @param turma_ids [Array<String>] os IDs das turmas
  # @param template [Template] o template a ser associado aos formulários
  # @return [Integer] o número de formulários criados
  # @note Cria avaliações para todos os usuários não administradores de cada turma.
  def criarFormularioTurmas(turma_ids, template)
    formularios_criados = 0
    turma_ids.each do |turma_id|
      turma = Turma.find(turma_id)

      formulario = Formulario.create!(
        nome: template.nome,
        template: template,
        turma: turma
      )

      turma.users.each do |user|
        next if user.admin?

        Avaliacao.create!(
          user: user,
          formulario: formulario,
          status: :pendente
        )
      end

      formularios_criados += 1
    end
    return formularios_criados
  end

  # Cria novos formulários de avaliação a partir de um template para turmas selecionadas.
  #
  # @return [void]
  # @note Redireciona para a listagem de formulários com uma mensagem de sucesso.
  def create
    template_id = params[:template_id]
    turma_ids = params[:turma_ids] || []

    if formularioValido(template_id, turma_ids)
      return
    end

    template = Template.find(template_id)
    formularios = criarFormularioTurmas(turma_ids, template)

    redirect_to admin_formularios_path,
                notice: "Formulário '#{template.nome}' foi gerado e enviado para #{formularios} turma(s)."
  end

  # Exclui um formulário de avaliação e suas avaliações associadas.
  #
  # @return [void]
  # @note Redireciona com mensagem de sucesso ou erro.
  def destroy
    begin
      formulario_nome = @formulario.nome
      turma_nome = @formulario.turma.nome

      @formulario.avaliacoes.destroy_all
      @formulario.destroy

      redirect_to admin_formularios_path,
                  notice: "Formulário '#{formulario_nome}' da turma '#{turma_nome}' foi excluído com sucesso."
    rescue => e
      redirect_to admin_formularios_path,
                  alert: "Erro ao excluir formulário: #{e.message}"
    end
  end

  private

  # Define a instância @formulario com base no ID passado pela URL.
  #
  # @return [void]
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end

  # Garante que apenas usuários administradores acessem as ações do controller.
  #
  # @return [void]
  # @note Redireciona para a raiz com mensagem de acesso negado, se o usuário não for admin.
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Acesso negado.'
    end
  end
end
