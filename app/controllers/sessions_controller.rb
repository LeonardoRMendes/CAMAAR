class SessionsController < ApplicationController
  def new
  end
  
  def create
    user = User.find_by(email: params[:email])
    
    Rails.logger.debug "=== LOGIN DEBUG ==="
    Rails.logger.debug "Email: #{params[:email]}"
    Rails.logger.debug "User found: #{user.present?}"
    Rails.logger.debug "Password digest present: #{user&.password_digest.present?}"
    
    if user.nil?
      flash.now[:alert] = 'Usuário não encontrado.'
      render :new
    elsif !user.password_digest.present?
      flash.now[:alert] = 'Senha não foi definida para este usuário.'
      render :new
    else
      auth_result = user.authenticate(params[:password])
      Rails.logger.debug "Authentication result: #{auth_result}"
      
      if auth_result
        session[:user_id] = user.id
        redirect_to dashboard_path, notice: 'Login realizado com sucesso!'
      else
        flash.now[:alert] = 'Senha inválida.'
        render :new
      end
    end
  end
  
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logout realizado com sucesso!'
  end
end
