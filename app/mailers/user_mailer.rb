class UserMailer < ApplicationMailer
  default from: 'noreply@camaar.unb.br'

  # Envia e-mail para o usuário recém-cadastrado com o link para definir a senha.
  #
  # @return [Mail::Message] o e-mail preparado para envio
  # @note Requer que `params[:user]` e `params[:token]` estejam definidos.
  def password_setup_email
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: 'Bem-vindo ao CAMAAR! Defina sua senha.')
  end
end
