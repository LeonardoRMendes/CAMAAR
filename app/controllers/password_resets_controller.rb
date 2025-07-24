class PasswordResetsController < ApplicationController
  def edit
    @user = User.find_signed(params[:token], purpose: "password_setup")
    if @user.nil?
      redirect_to login_path, alert: 'Link para definição de senha inválido ou expirado.'
    end
  end

  def update
    @user = User.find_signed(params[:token], purpose: "password_setup")
    
    if @user.nil?
      redirect_to login_path, alert: 'Link para definição de senha inválido ou expirado.'
      return
    end

    if @user.update(password_params)
      redirect_to login_path, notice: 'Senha definida com sucesso! Você já pode fazer login.'
    else
      flash.now[:alert] = @user.errors.full_messages.to_sentence
      render :edit, status: :unprocessable_entity
    end
  end

  private
  
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
