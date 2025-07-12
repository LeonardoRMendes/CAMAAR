class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    if user&.password_set? && user.authenticate(params[:password])
      session[:user_id] = user.id
      redirect_to dashboard_path, notice: 'Login realizado com sucesso!'
    elsif user&.password_digest.blank?
      flash.now[:alert] = 'Você precisa definir sua senha. Verifique seu e-mail para o link de definição de senha.'
      render :new
    else
      flash.now[:alert] = 'E-mail ou senha inválidos.'
      render :new
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logout realizado com sucesso!'
  end
end
