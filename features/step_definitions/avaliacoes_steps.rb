Dado('que existe a turma {string}') do |nome_turma|
  @turma = Turma.create!(nome: nome_turma)
end

Dado('que eu estou matriculado na turma {string}') do |nome_turma|
  turma = Turma.find_by(nome: nome_turma)
  @matricula = Matricula.create!(user: @user, turma: turma)
end

Quando('eu faço login com e-mail {string} e senha {string}') do |email, senha|
  visit '/login'
  fill_in 'email', with: email
  fill_in 'password', with: senha
  click_button 'Entrar'
end

Quando('eu vou para a página {string}') do |pagina|
  case pagina
  when 'Minhas Avaliações'
    visit '/minhas_avaliacoes'
  else
    visit "/#{pagina.downcase.gsub(' ', '_')}"
  end
end

Dado('que a turma {string} possui o formulário {string} para ser respondido') do |nome_turma, nome_formulario|
  turma = Turma.find_by(nome: nome_turma)
  @formulario = Formulario.create!(
    nome: nome_formulario,
    turma: turma
  )
end

Dado('que a turma {string} não possui formulários pendentes para mim') do |nome_turma|
end

Dado('que eu sou um {string} logado') do |tipo_usuario|
  @user = User.create!(
    email: "participante@unb.br",
    password: "senha123", 
    password_confirmation: "senha123"
  )
  
  visit '/login'
  fill_in 'email', with: @user.email
  fill_in 'password', with: 'senha123'
  click_button 'Entrar'
end

Dado('que a turma {string} possui o formulário {string}') do |nome_turma, nome_formulario|
  @turma = Turma.find_or_create_by!(nome: nome_turma)
  @formulario = Formulario.create!(nome: nome_formulario, turma: @turma)
  
  unless @user.turmas.include?(@turma)
    Matricula.create!(user: @user, turma: @turma)
  end
end

Dado('o formulário {string} possui a questão obrigatória {string}') do |nome_formulario, texto_questao|
  formulario = Formulario.find_by!(nome: nome_formulario)
  @questao = Questao.create!(texto: texto_questao, formulario: formulario, obrigatoria: true)
end

Dado('que eu estou na página de resposta do formulário {string}') do |nome_formulario|
  formulario = Formulario.find_by!(nome: nome_formulario)
  visit formulario_path(formulario)
end

Quando('eu preencho a resposta para {string} com {string}') do |texto_questao, texto_resposta|
  fill_in(texto_questao, with: texto_resposta)
end

Quando('eu clico no botão {string} sem preencher os campos obrigatórios') do |button_text|
  click_button(button_text)
end

Então('eu devo ver o card da turma {string}') do |nome_turma|
  expect(page).to have_content(nome_turma)
  expect(page).to have_css('.turma-card', text: nome_turma)
end

Então('dentro do card da turma, eu devo ver o link para a avaliação {string}') do |nome_avaliacao|
  within('.turma-card') do
    expect(page).to have_link(nome_avaliacao)
  end
end

Então('dentro do card da turma, eu devo ver a mensagem {string}') do |mensagem|
  within('.turma-card') do
    expect(page).to have_content(mensagem)
  end
end

Então('eu devo ser redirecionado para a página de {string}') do |nome_pagina|
  case nome_pagina
  when 'Minhas Avaliações'
    expect(current_path).to eq('/minhas_avaliacoes')
  end
end

Então('a avaliação {string} não deve mais ser exibida como pendente') do |nome_formulario|
  expect(page).not_to have_link(nome_formulario)
end

Então('eu devo permanecer na página de resposta da avaliação') do
  expect(current_path).to match(/\/formularios\/\d+/)
end
