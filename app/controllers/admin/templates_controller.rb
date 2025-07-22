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
  
  def create
    @template = Template.new(template_params)
    
    if @template.nome.blank?
      flash.now[:alert] = "O template deve ter um nome"
      render :new
      return
    end
    
    if params[:questoes].blank? || params[:questoes].all? { |q| q[:texto].blank? }
      flash.now[:alert] = "O template deve ter pelo menos uma questão"
      render :new
      return
    end
    
    @template.save!
    
    params[:questoes].each do |questao_params|
      next if questao_params[:texto].blank?
      
      opcoes = nil
      if questao_params[:tipo] == 'multipla_escolha' && questao_params[:opcoes_texto].present?
        # Converter texto das opções em array
        opcoes = questao_params[:opcoes_texto].split("\n").map(&:strip).reject(&:blank?)
      end
      
      @template.questoes.create!(
        texto: questao_params[:texto],
        obrigatoria: questao_params[:obrigatoria] == '1',
        tipo: questao_params[:tipo] || 'texto',
        opcoes: opcoes
      )
    end
    
    redirect_to admin_templates_path, notice: "Template '#{@template.nome}' criado com sucesso"
  end
  
  def edit
  end
  
  def update
    if @template.nome.blank?
      flash.now[:alert] = "O template deve ter um nome"
      render :edit
      return
    end
    
    if params[:questoes_existentes]
      params[:questoes_existentes].each do |id, questao_params|
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
    
    if params[:questoes_novas]
      params[:questoes_novas].each do |index, questao_params|
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
    
    if params[:questoes_remover]
      params[:questoes_remover].each do |id|
        next if id.blank?
        questao = @template.questoes.find(id)
        questao.destroy
      end
    end
    
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
