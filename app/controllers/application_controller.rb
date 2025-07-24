class ApplicationController < ActionController::Base
  private
  # Retorna o usuário atualmente autenticado com base no ID armazenado na sessão.
  #
  # @return [User, nil] o usuário autenticado ou nil se não houver usuário logado
  # @note Este método é disponibilizado para as views via `helper_method`
  # @see #helper_method
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user
end
