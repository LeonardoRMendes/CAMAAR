# features/step_definitions/admin_resultados_steps.rb

Dado('que um formulário sobre {string} foi respondido por um participante com a resposta {string} para a questão {string}') do |nome_formulario, texto_resposta, texto_questao|
  # 1. Cria os dados base
  participante = FactoryBot.create(:user, role: :participante)
  turma = FactoryBot.create(:turma)
  template = FactoryBot.create(:template)
  questao = FactoryBot.create(:questao, texto: texto_questao, template: template)

  # 2. Cria o formulário para a turma
  formulario = FactoryBot.create(:formulario, nome: nome_formulario, template: template, turma: turma)

  # 3. Cria a "tarefa" de avaliação para o participante
  avaliacao = FactoryBot.create(:avaliacao, user: participante, formulario: formulario, status: :concluida)

  # 4. Cria a resposta efetiva do participante
  FactoryBot.create(:resposta, conteudo: texto_resposta, questao: questao, user: participante, avaliacao: avaliacao)
end

Dado('que o formulário {string} foi criado mas não foi respondido por ninguém') do |nome_formulario|
  turma = FactoryBot.create(:turma)
  template = FactoryBot.create(:template)
  FactoryBot.create(:formulario, nome: nome_formulario, template: template, turma: turma)
end

Dado('eu sou um {string} logado') do |tipo_usuario|
  if tipo_usuario == "Administrador"
    admin_user = FactoryBot.create(:user, email: "admin@test.com", password: "senha123", password_confirmation: "senha123", role: :admin)
    visit login_path
    fill_in 'Email', with: 'admin@test.com'
    fill_in 'Senha', with: 'senha123'
    click_button 'Entrar'
  end
end

Quando('eu vou para a página de {string}') do |nome_pagina|
  case nome_pagina
  when "Resultados"
    visit admin_resultados_path
  end
end

Quando('eu clico para ver os resultados do formulário {string}') do |nome_formulario|
  # Supondo uma lista de formulários na página de resultados
  # e cada um tem um link para seus resultados.
  formulario = Formulario.find_by(nome: nome_formulario)
  click_link "Ver Resultados", href: admin_resultado_path(formulario.id)
end

Então('eu devo ver o título da questão {string}') do |texto_questao|
  expect(page).to have_content(texto_questao)
end

Então('eu devo ver a resposta {string} com a contagem de {string}') do |texto_resposta, contagem|
  # Supondo uma estrutura de lista para as respostas e suas contagens
  within('.questao-results') do
    expect(page).to have_content("#{texto_resposta}: #{contagem}")
  end
end

Então('eu devo ver a mensagem {string}') do |mensagem|
  expect(page).to have_content(mensagem)
end
