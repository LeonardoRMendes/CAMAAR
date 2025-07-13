require 'rails_helper'

# Funcionalidade: Definição de Senha para Novos Usuários
RSpec.feature "Definição de Senha para Novos Usuários", type: :feature do

  # Contexto:
  # Cria um usuário sem senha definida, mas com um token para a definição de senha.
  # Nota: O mecanismo de token pode variar. Aqui, estamos simulando um token simples.
  # Adapte a criação do token se seu modelo User usar um método específico.
  let!(:new_user) { create(:user, email: 'novo.participante@email.com', password_digest: nil, password_reset_token: 'token_valido_aqui') }

  # Cenário: Usuário define a senha com sucesso usando um token válido
  scenario "Usuário define a senha com sucesso usando um token válido" do
    # Quando eu abro o link de definição de senha recebido no e-mail
    # Nota: A rota 'edit_password_reset_path' é uma suposição. Altere se necessário.
    visit edit_password_reset_path(new_user.password_reset_token)

    # E eu preencho o campo "Nova Senha" com "umaSenhaForte123"
    fill_in 'Nova Senha', with: 'umaSenhaForte123'
    
    # E eu preencho o campo "Confirmação da Senha" com "umaSenhaForte123"
    fill_in 'Confirmação da Senha', with: 'umaSenhaForte123'
    
    # E eu clico no botão "Definir Senha"
    click_button 'Definir Senha'
    
    # Então eu devo ser redirecionado para a página de "Login"
    expect(page).to have_current_path(login_path)
    
    # E eu devo ver a mensagem "Senha definida com sucesso! Você já pode fazer login."
    expect(page).to have_content('Senha definida com sucesso! Você já pode fazer login.')
    
    # E agora eu consigo fazer login com o e-mail "novo.participante@email.com" e senha "umaSenhaForte123"
    fill_in 'E-mail', with: 'novo.participante@email.com'
    fill_in 'Senha', with: 'umaSenhaForte123'
    click_button 'Entrar'
    expect(page).to have_current_path(dashboard_path) # Assumindo redirecionamento para o dashboard
  end

  # Cenário: Usuário tenta usar um link com token inválido
  scenario "Usuário tenta usar um link com token inválido" do
    # Quando eu tento visitar a página de definição de senha com um token inválido
    visit edit_password_reset_path('token_invalido')
    
    # Então eu devo ser redirecionado para a página de "Login"
    expect(page).to have_current_path(login_path)
    
    # E eu devo ver a mensagem de erro "Link para definição de senha inválido ou expirado."
    expect(page).to have_content('Link para definição de senha inválido ou expirado.')
  end

  # Cenário: Usuário digita senhas que não correspondem
  scenario "Usuário digita senhas que não correspondem" do
    # Quando eu abro o link de definição de senha recebido no e-mail
    visit edit_password_reset_path(new_user.password_reset_token)
    
    # E eu preencho o campo "Nova Senha" com "senhaBoa1"
    fill_in 'Nova Senha', with: 'senhaBoa1'
    
    # E eu preencho o campo "Confirmação da Senha" com "senhaRuim2"
    fill_in 'Confirmação da Senha', with: 'senhaRuim2'
    
    # E eu clico no botão "Definir Senha"
    click_button 'Definir Senha'
    
    # Então eu devo permanecer na página de definição de senha
    expect(page).to have_current_path(edit_password_reset_path(new_user.password_reset_token))
    
    # E eu devo ver a mensagem de erro "A confirmação de senha não corresponde à senha."
    # Nota: A mensagem exata pode variar dependendo da sua configuração de i18n do Rails.
    expect(page).to have_content('A confirmação de senha não corresponde à senha.')
  end
end
