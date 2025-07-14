require 'rails_helper'

# Funcionalidade: Autenticação de Usuário
RSpec.feature "Autenticação de Usuário", type: :feature do

  # Contexto: Cria o usuário necessário antes de cada cenário
  # Usamos let! para garantir que o usuário exista no banco antes dos testes começarem.
  let!(:user) { create(:user, email: 'aluno@email.com', password: 'senha123', password_confirmation: 'senha123') }

  # Cenário: Login bem-sucedido com credenciais válidas
  scenario "Login bem-sucedido com credenciais válidas" do
    # Quando eu vou para a página de login
    visit login_path

    # E eu preencho o campo "E-mail" com "aluno@email.com"
    fill_in 'E-mail', with: 'aluno@email.com'
    
    # E eu preencho o campo "Senha" com "senha123"
    fill_in 'Senha', with: 'senha123'
    
    # E eu clico no botão "Entrar"
    click_button 'Entrar'
    
    # Então eu devo estar logado e ver meu nome no dashboard
    expect(page).to have_content('Bem-vindo, Nome do Usuário')
    
    # E eu devo estar na página principal do participante
    expect(page).to have_current_path(dashboard_path) 
  end

  # Cenário: Falha no login com senha incorreta
  scenario "Falha no login com senha incorreta" do
    # Quando eu vou para a página de login
    visit login_path
    
    # E eu preencho o campo "E-mail" com "aluno@email.com"
    fill_in 'E-mail', with: 'aluno@email.com'
    
    # E eu preencho o campo "Senha" com "senha_errada"
    fill_in 'Senha', with: 'senha_errada'
    
    # E eu clico no botão "Entrar"
    click_button 'Entrar'
    
    # Então eu devo ver a mensagem de erro
    expect(page).to have_content('Senha inválida.')
    
    # E eu devo permanecer na página de login
    expect(page).to have_current_path(login_path)
  end
end
