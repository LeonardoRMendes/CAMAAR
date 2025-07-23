require 'rails_helper'

RSpec.feature "Autenticação de Usuário", type: :feature do
  let!(:user) { create(:user, email: 'aluno@email.com', password: 'senha123', password_confirmation: 'senha123') }

  scenario "Login bem-sucedido com credenciais válidas" do
    visit login_path

    fill_in 'E-mail', with: 'aluno@email.com'
    fill_in 'Senha', with: 'senha123'
    click_button 'Entrar'

    expect(page).to have_content('Bem-vindo, Nome do Usuário')
    expect(page).to have_current_path(dashboard_path)
  end

  scenario "Falha no login com senha incorreta" do
    visit login_path

    fill_in 'E-mail', with: 'aluno@email.com'
    fill_in 'Senha', with: 'senha_errada'
    click_button 'Entrar'

    expect(page).to have_content('Senha inválida.')
    expect(page).to have_current_path(login_path)
  end

  scenario "Falha no login com usuário inexistente" do
    visit login_path

    fill_in 'E-mail', with: 'naoexiste@email.com'
    fill_in 'Senha', with: 'qualquer'
    click_button 'Entrar'

    expect(page).to have_content('Usuário não encontrado.')
    expect(page).to have_current_path(login_path)
  end

  scenario "Falha no login com usuário sem senha definida" do
    user_sem_senha = create(:user, email: 'sem_senha@email.com', password_digest: nil)

    visit login_path
    fill_in 'E-mail', with: user_sem_senha.email
    fill_in 'Senha', with: 'qualquer'
    click_button 'Entrar'

    expect(page).to have_content('Senha não foi definida para este usuário.')
    expect(page).to have_current_path(login_path)
  end

  scenario "Logout com sucesso" do
    # Login
    visit login_path
    fill_in 'E-mail', with: 'aluno@email.com'
    fill_in 'Senha', with: 'senha123'
    click_button 'Entrar'

    # Logout
    click_link 'Sair'

    expect(page).to have_content('Logout realizado com sucesso!')
    expect(page).to have_current_path(login_path)
  end
end
