class FormulariosController < ApplicationController
  before_action :require_login
  
  def show
    @formulario = Formulario.find(params[:id])
    @questoes = @formulario.questoes.order(:id)
  end
  
  private
  
  def require_login
    unless current_user
      redirect_to login_path, alert: 'Você precisa fazer login primeiro.'
    end
  end
end
