Dado('que existe o template {string}') do |nome_template|
  @template = Template.create!(nome: nome_template)
  @template.questoes.create!(texto: "Qual sua opinião?", obrigatoria: false)
end

Dado('existem as turmas {string} e {string} cadastradas no sistema') do |turma1, turma2|
  @turma1 = Turma.create!(nome: turma1)
  @turma2 = Turma.create!(nome: turma2)
  
  @participante = User.create!(
    email: "aluno@camaar.com",
    password: "senha123",
    password_confirmation: "senha123",
    role: :participante
  )
  
  Matricula.create!(user: @participante, turma: @turma1)
end

Quando('eu vou para a página de {string}') do |nome_pagina|
  case nome_pagina
  when "Gerenciamento de Templates"
    visit '/admin/templates'
  when "Gerenciamento de Formulários"
    visit '/admin/formularios'
  else
    raise "Página não mapeada: #{nome_pagina}"
  end
end

Quando('eu clico em {string}') do |link_text|
  click_link(link_text)
end

Quando('eu seleciono o template {string}') do |nome_template|
  select(nome_template, from: 'template_id')
end

Quando('eu seleciono a turma {string}') do |nome_turma|
  check(nome_turma)
end

Então('eu devo permanecer na página de criação de formulário') do
  expect(current_path).to eq('/admin/formularios/new')
end

Então('o participante {string} matriculado na turma {string} deve ter uma avaliação pendente') do |email_participante, nome_turma|
  participante = User.find_by!(email: email_participante)
  turma = Turma.find_by!(nome: nome_turma)
  
  formulario = Formulario.find_by!(turma: turma)
  
  avaliacao_pendente = Avaliacao.find_by(user: participante, formulario: formulario)
  expect(avaliacao_pendente).not_to be_nil
  expect(avaliacao_pendente.status).to eq('pendente')
end
