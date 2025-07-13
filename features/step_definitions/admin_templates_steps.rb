Dado('que eu sou um {string} logado') do |role|
  email = "admin@camaar.com"
  senha = "password123"
  
  case role.downcase
  when 'administrador', 'admin'
    @current_user = User.create!(
      email: email, 
      password: senha, 
      password_confirmation: senha,
      role: :admin
    )
  else
    @current_user = User.create!(
      email: email, 
      password: senha, 
      password_confirmation: senha,
      role: :participante
    )
  end

  visit '/login'
  fill_in('email', with: email)
  fill_in('password', with: senha)
  click_button('Entrar')
end

Quando('eu vou para a página de {string}') do |nome_pagina|
  case nome_pagina
  when "Gerenciamento de Templates"
    visit '/admin/templates'
  else
    raise "Página não mapeada: #{nome_pagina}"
  end
end

Quando('eu clico no botão {string}') do |button_text|
  click_on(button_text)
end

Quando('eu preencho o campo {string} com {string}') do |field, value|
  fill_in(field, with: value)
end

Quando('eu adiciono a questão {string}') do |texto_questao|
  fill_in('Texto da Questão 1', with: texto_questao)
end

Então('eu devo ver a mensagem {string}') do |message|
  expect(page).to have_content(message)
end

Então('eu devo ver a mensagem de erro {string}') do |message|
  expect(page).to have_css('.alert-danger', text: message)
end

Então('eu devo ver {string} na lista de templates') do |nome_template|
  expect(page).to have_content(nome_template)
end

Dado('que existe um template com o nome {string}') do |nome_template|
  @template = FactoryBot.create(:template, nome: nome_template)
end

Dado('que o template {string} já foi usado para criar um formulário') do |nome_template|
  @template = FactoryBot.create(:template, nome: nome_template)
  
  turma = FactoryBot.create(:turma, codigo: "TST123", nome: "Turma de Teste")
  
  FactoryBot.create(:formulario,
    nome: "Formulário de Teste",
    turma: turma,
    template: @template
  )
end

Quando('eu clico em {string} para o template {string}') do |acao, nome_template|
  within('table') do
    template_row = find('tr', text: nome_template)
    case acao
    when "Editar"
      template_row.click_link('Editar')
    when "Excluir"
      template_row.click_link('Excluir')
    end
  end
end

Então('eu não devo mais ver {string} na lista') do |nome_template|
  expect(page).not_to have_content(nome_template)
end

Então('eu não devo mais ver {string} na lista de templates') do |nome_template|
  expect(page).not_to have_content(nome_template)
end

Então('eu ainda devo ver {string} na lista de templates') do |nome_template|
  expect(page).to have_content(nome_template)
end
