Dado('que existe um usuário com o e-mail {string} e senha {string}') do |email, senha|
  @user = User.create!(
    email: email,
    password: senha,
    password_confirmation: senha
  )
end

Quando('eu vou para a página de login') do
  visit '/login'
end

Quando('eu preencho o campo {string} com {string}') do |campo, valor|
  case campo.downcase
  when 'e-mail', 'email'
    fill_in 'email', with: valor
  when 'senha', 'password'
    fill_in 'password', with: valor
  else
    fill_in campo, with: valor
  end
end

Quando('eu clico no botão {string}') do |botao|
  case botao.downcase
  when 'entrar', 'login'
    click_button 'Entrar'
  else
    click_button botao
  end
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('eu devo ver a mensagem de erro {string}') do |mensagem_erro|
  expect(page).to have_content(mensagem_erro)
end

Então('eu devo estar na página principal do participante') do
  expect(current_path).to eq('/dashboard')
end

Então('eu devo permanecer na página de login') do
  expect(current_path).to eq('/login')
end
