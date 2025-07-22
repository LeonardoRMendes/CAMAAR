class UserMailer < ApplicationMailer
  default from: 'noreply@camaar.unb.br'

  def password_setup_email
    @user = params[:user]
    @token = params[:token]
    mail(to: @user.email, subject: 'Bem-vindo ao CAMAAR! Defina sua senha.')
  end
end
