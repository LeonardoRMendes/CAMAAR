class Admin::TemplatesController < ApplicationController
  before_action :require_admin
  before_action :set_template, only: [:edit, :update, :destroy]
  
  def index
    @templates = Template.all
  end
  
  def new
    @template = Template.new
    @template.questoes.build
  end
  
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
  
  def criarQuestao(questao)
    opcoes = nil
    if questao[:tipo] == 'multipla_escolha' && questao[:opcoes_texto].present?
        # Converter texto das opções em array
        opcoes = questao[:opcoes_texto].split("\n").map(&:strip).reject(&:blank?)
    end
    @template.questoes.create!(
        texto: questao[:texto],
        obrigatoria: questao[:obrigatoria] == '1',
        tipo: questao[:tipo] || 'texto',
        opcoes: opcoes
    )
  end

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
  
  def edit
  end
  

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

  def removerQuestoes(questaoR)
    if questaoR
      questaoR.each do |id|
        next if id.blank?
        questao = @template.questoes.find(id)
        questao.destroy
      end
    end
  end

  def nomeValidoupdate
    if @template.nome.blank?
      flash.now[:alert] = "O template deve ter um nome"
      render :edit
      return true
    end
  end

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
  
  def set_template
    @template = Template.find(params[:id])
  end
  
  def template_params
    params.require(:template).permit(:nome, :descricao)
  end
  
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Acesso negado.'
    end
  end
end
