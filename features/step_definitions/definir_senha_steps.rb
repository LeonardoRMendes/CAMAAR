# features/step_definitions/definir_senha_steps.rb

Dado('que um usuário foi criado com o e-mail {string} e ele recebeu um e-mail para definição de senha') do |email|
  # Criamos o usuário e um token para ele
  @user = FactoryBot.create(:user, :without_password, email: email)
  @token = @user.signed_id(purpose: "password_setup", expires_in: 15.minutes)

  # Simulamos o envio do e-mail (a lógica real estaria no controller ou service)
  UserMailer.with(user: @user, token: @token).password_setup_email.deliver_now
end

Quando('eu abro o link de definição de senha recebido no e-mail') do
  # O Rails armazena os e-mails enviados em um array para testes
  sent_email = ActionMailer::Base.deliveries.last
  # Extraímos o link do corpo do e-mail
  link_url = sent_email.body.to_s.match(/href="([^"]+)"/)[1]
  visit link_url
end

Quando('eu preencho o campo {string} com {string}') do |field, value|
  fill_in(field, with: value)
end

Então('agora eu consigo fazer login com o e-mail {string} e senha {string}') do |email, senha|
  visit '/login'
  fill_in('Email', with: email)
  fill_in('Senha', with: senha)
  click_button('Entrar')
  expect(page).to have_content("Login realizado com sucesso!" || "Dashboard")
end

Quando('eu tento visitar a página de definição de senha com um token inválido') do
  visit "/password_resets/invalid_token/edit"
end

Então('eu devo permanecer na página de definição de senha') do
  expect(current_path).to match(/\/password_resets\/.*\/edit/)
end

Então('eu devo ser redirecionado para a página de {string}') do |pagina|
  case pagina
  when "Login"
    expect(current_path).to eq(login_path)
  end
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end

Então('eu devo ver a mensagem de erro {string}') do |mensagem_erro|
  expect(page).to have_content(mensagem_erro)
end
