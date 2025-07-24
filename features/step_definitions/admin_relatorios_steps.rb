# features/step_definitions/admin_relatorios_steps.rb

Dado('que eu estou na página de resultados do formulário {string}') do |nome_formulario|
  formulario = Formulario.find_by!(nome: nome_formulario)
  visit admin_resultado_path(formulario) # Assumindo a rota '.../:id'
end

Quando('eu clico no link {string}') do |link_text|
  click_link(link_text)
end

Então('um arquivo chamado {string} deve ser baixado') do |filename|
  # Verifica se o cabeçalho da resposta instrui o navegador a baixar o arquivo com o nome correto
  expect(page.response_headers['Content-Disposition']).to include("attachment; filename=\"#{filename}\"")
  expect(page.response_headers['Content-Type']).to eq('text/csv')
end

Então('o conteúdo do arquivo CSV deve conter o cabeçalho {string}') do |header_row|
  # 'page.body' contém o corpo da resposta, que é o nosso CSV
  expect(page.body).to include(header_row)
end

Então('o conteúdo do arquivo CSV deve conter a linha {string}') do |content_row|
  expect(page.body).to include(content_row)
end

Dado('que ocorre um erro no servidor ao tentar gerar o CSV para o formulário {string}') do |nome_formulario|
  allow_any_instance_of(CsvExportService).to receive(:generate).and_raise(StandardError)
end

Então('eu devo permanecer na página de resultados') do
  expect(current_path).to match(/\/admin\/resultados\/\d+/)
end

Então('eu devo ver a mensagem de erro {string}') do |mensagem_erro|
  expect(page).to have_content(mensagem_erro)
end
