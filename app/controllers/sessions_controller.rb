# Controlador responsável pela autenticação de usuários no sistema.
class SessionsController < ApplicationController
  # Exibe o formulário de login.
  #
  # @return [void]
  def new
  end
  
  # Registra informações úteis para depuração durante o login.
  #
  # @param user [User, nil] o usuário encontrado com base no e-mail fornecido
  # @return [void]
  # @note Apenas escreve no log; não altera o estado do sistema.
  def logSection(user)
    Rails.logger.debug "=== LOGIN DEBUG ==="
    Rails.logger.debug "Email: #{params[:email]}"
    Rails.logger.debug "User found: #{user.present?}"
    Rails.logger.debug "Password digest present: #{user&.password_digest.present?}"
  end

  # Valida a senha do usuário e realiza o login se for válida.
  #
  # @param user [User] o usuário autenticável
  # @return [void]
  # @note Se a senha estiver correta, salva o ID do usuário na sessão
  #   e redireciona para o dashboard; caso contrário, renderiza o formulário novamente.
  def testarSenha(user)
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

  # Cria a sessão do usuário, caso as credenciais estejam corretas.
  #
  # @return [void]
  # @note Redireciona para o dashboard se o login for bem-sucedido;
  #   caso contrário, exibe mensagens de erro no próprio formulário.
  def create
    user = User.find_by(email: params[:email])
    logSection(user)

    if user.nil?
      flash.now[:alert] = 'Usuário não encontrado.'
      render :new
    elsif !user.password_digest.present?
      flash.now[:alert] = 'Senha não foi definida para este usuário.'
      render :new
    else
      testarSenha(user)
    end
  end

  # Realiza o logout do usuário atual.
  #
  # @return [void]
  # @note Limpa o ID da sessão e redireciona para a tela de login.
  def destroy
    session[:user_id] = nil
    redirect_to login_path, notice: 'Logout realizado com sucesso!'
  end
end
