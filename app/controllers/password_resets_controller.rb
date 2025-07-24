# Controlador para redefinição de senha via link assinado.
class PasswordResetsController < ApplicationController
  # Exibe o formulário de redefinição de senha.
  #
  # @return [void]
  # @note Redireciona para login se o token for inválido ou expirado.
  def edit
    @user = User.find_signed(params[:token], purpose: "password_setup")
    if @user.nil?
      redirect_to login_path, alert: 'Link para definição de senha inválido ou expirado.'
    end
  end

  # Atualiza a senha do usuário.
  #
  # @return [void]
  # @note Redireciona para login se sucesso, ou renderiza :edit com erro.
  # @param [ActionController::Parameters] params contendo :password e :password_confirmation
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

  # Filtra os parâmetros permitidos para redefinição de senha.
  #
  # @return [ActionController::Parameters] parâmetros permitidos
  def password_params
    params.require(:user).permit(:password, :password_confirmation)
  end
end
