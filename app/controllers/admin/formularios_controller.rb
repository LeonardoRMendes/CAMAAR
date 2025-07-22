class Admin::FormulariosController < ApplicationController
  before_action :require_admin
  before_action :set_formulario, only: [:destroy]
  
  def index
    @formularios = Formulario.includes(:template, :turma).all
  end
  
  def new
    @templates = Template.all
    @turmas = Turma.all
  end
  
  def create
    template_id = params[:template_id]
    turma_ids = params[:turma_ids] || []
    
    if template_id.blank?
      flash.now[:alert] = "É necessário selecionar um template."
      @templates = Template.all
      @turmas = Turma.all
      render :new
      return
    end
    
    if turma_ids.empty?
      flash.now[:alert] = "É necessário selecionar pelo menos uma turma."
      @templates = Template.all
      @turmas = Turma.all
      render :new
      return
    end
    
    template = Template.find(template_id)
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
    
    redirect_to admin_formularios_path, 
                notice: "Formulário '#{template.nome}' foi gerado e enviado para #{formularios_criados} turma(s)."
  end
  
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
  
  def set_formulario
    @formulario = Formulario.find(params[:id])
  end
  
  def require_admin
    unless current_user&.admin?
      redirect_to root_path, alert: 'Acesso negado.'
    end
  end
end
