Quando('eu anexo o arquivo {string} ao campo de upload {string}') do |filename, field_name|
  file_path = Rails.root.join('test', 'fixtures', 'files', filename)
  attach_file(field_name, file_path)
end

Então('eu devo ver uma mensagem de sucesso detalhando os dados importados') do
  expect(page).to have_content(/importado com sucesso/i)
end

def load_json_data(filename)
  file_path = Rails.root.join('test', 'fixtures', 'files', filename)
  @json_data = JSON.parse(File.read(file_path))
end

Então('o usuário correspondente ao primeiro discente do arquivo JSON deve existir no banco de dados') do
  load_json_data('class_members_new.json') unless @json_data
  primeiro_discente_email = @json_data['discentes'].first['email']
  expect(User.find_by(email: primeiro_discente_email)).not_to be_nil
end

Então('a turma correspondente à primeira turma do arquivo JSON deve existir no banco de dados') do
  load_json_data('class_members_new.json') unless @json_data
  primeira_turma_id = @json_data['turmas'].first['id_turma']
  expect(Turma.find_by(sigaa_id: primeira_turma_id)).not_to be_nil
end

Dado('que eu crio um arquivo de teste {string} com o conteúdo {string}') do |filename, content|
  file_path = Rails.root.join('test', 'fixtures', 'files', filename)
  File.open(file_path, 'w') { |f| f.write(content) }
end

Dado('que a primeira turma e o primeiro discente do arquivo {string} já existem no banco') do |filename|
  load_json_data(filename)
  turma_data = @json_data['turmas'].first
  discente_data = @json_data['discentes'].first

  FactoryBot.create(:turma, sigaa_id: turma_data['id_turma'], nome: turma_data['codigo_componente'], ano: turma_data['ano'], periodo: turma_data['periodo'])
  FactoryBot.create(:user, email: discente_data['email'], nome: discente_data['nome'], matricula: discente_data['matricula'])
end

Então('a mensagem de sucesso deve indicar que {string}') do |message_part|
  expect(page).to have_content(message_part)
end

Dado('que existe um usuário administrador com email {string} e senha {string}') do |email, password|
  FactoryBot.create(:user, email: email, password: password, password_confirmation: password, role: :admin)
end

Dado('que eu estou logado como administrador') do
  visit login_path
  fill_in 'Email', with: 'admin@test.com'
  fill_in 'Senha', with: 'senha123'
  click_button 'Entrar'
end

Dado('que eu estou na página de importação de dados') do
  visit admin_importacoes_path
end

Dado('que eu tenho um arquivo JSON válido com dados de turmas e discentes') do
end

Quando('eu clico em {string}') do |button_text|
  click_button button_text
end

Quando('eu clico em {string} sem selecionar um arquivo') do |button_text|
  click_button button_text
end

Então('eu devo ver a mensagem {string}') do |message|
  expect(page).to have_content(message)
end