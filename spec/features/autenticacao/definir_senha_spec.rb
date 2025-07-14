require 'rails_helper'

RSpec.feature "Definição de Senha para Novos Usuários", type: :feature do

  let!(:new_user) { create(:user, :without_password, email: 'novo.participante@email.com') }
  let!(:valid_token) { new_user.signed_id(purpose: "password_setup") }

  scenario "Usuário define a senha com sucesso usando um token válido" do
    visit password_reset_edit_path(valid_token)

    fill_in 'Nova Senha', with: 'umaSenhaForte123'
    
    fill_in 'Confirmação da Senha', with: 'umaSenhaForte123'
    
    click_button 'Definir Senha'
    
    expect(page).to have_current_path(login_path)
    
    expect(page).to have_content('Senha definida com sucesso! Você já pode fazer login.')
    
    fill_in 'E-mail', with: 'novo.participante@email.com'
    fill_in 'Senha', with: 'umaSenhaForte123'
    click_button 'Entrar'
    expect(page).to have_current_path(dashboard_path)
  end

  scenario "Usuário tenta usar um link com token inválido" do
    visit password_reset_edit_path('token_invalido')
    
    expect(page).to have_current_path(login_path)
    
    expect(page).to have_content('Link para definição de senha inválido ou expirado.')
  end

  scenario "Usuário digita senhas que não correspondem" do
    visit password_reset_edit_path(valid_token)
    
    fill_in 'Nova Senha', with: 'senhaBoa1'
    
    fill_in 'Confirmação da Senha', with: 'senhaRuim2'
    
    click_button 'Definir Senha'
    
    expect(current_path).to match(%r{/password_resets/.+})
    
    expect(page).to have_content("Password confirmation doesn't match Password")
  end
end
