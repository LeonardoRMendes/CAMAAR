require 'rails_helper'

# Funcionalidade: Exportar Relatórios de Resultados
RSpec.feature "Exportar Relatórios de Resultados", type: :feature do

  # --- Contexto (Setup) ---
  # Cria os dados necessários antes de cada cenário
  let!(:admin) { create(:user, role: :admin, email: 'admin@camaar.com', password: 'password123', password_confirmation: 'password123') }
  let!(:participante) { create(:user, role: :participante, email: 'participante@camaar.com', password: 'password123', password_confirmation: 'password123') }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }
  let!(:template) { create(:template) }
  let!(:questao) { create(:questao, template: template, texto: "Como você avalia a didática do professor?") }
  let!(:formulario) { create(:formulario, nome: 'Didática', template: template, turma: turma) }
  
  # Bloco que executa antes de cada cenário
  before do
    # Matricula o participante na turma
    turma.users << participante
    
    # Dado que um formulário sobre "Didática" foi respondido...
    avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :concluida)
    create(:resposta, avaliacao: avaliacao, questao: questao, conteudo: 'Excelente')

    # E eu sou um "Administrador" logado
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: admin.password
    click_button 'Entrar'

    # E eu estou na página de resultados dos formulários
    visit admin_resultados_path
  end

  # Cenário: Exportar resultados para CSV com sucesso
  scenario "Exportar resultados para CSV com sucesso" do
    # Primeiro verifica se o formulário está listado na página
    expect(page).to have_content('Didática')
    
    # Quando eu clico no link "Exportar CSV" na linha do formulário
    within('.table') do
      within('tr', text: 'Didática') do
        click_link 'Exportar CSV'
      end
    end
    
    # Então um arquivo chamado "didatica_resultados.csv" deve ser baixado
    # Verificamos o cabeçalho da resposta para confirmar o nome do arquivo
    expect(page.response_headers['Content-Disposition']).to include("filename=\"didatica_resultados.csv\"")
    expect(page.response_headers['Content-Type']).to eq('text/csv')
    
    # E o conteúdo do arquivo CSV deve conter o cabeçalho
    expect(page.body).to include("Questão,Resposta,Votos")
    
    # E o conteúdo do arquivo CSV deve conter a linha de dados
    expect(page.body).to include("Como você avalia a didática do professor?,Excelente,1")
  end

  # Cenário: Falha na geração do arquivo CSV
  scenario "Falha na geração do arquivo CSV" do
    # Dado que ocorre um erro no servidor ao tentar gerar o CSV
    # Simulamos falha no CsvExportService
    allow_any_instance_of(CsvExportService).to receive(:generate).and_raise(StandardError.new("Erro de Geração"))
    
    # Primeiro verifica se o formulário está listado na página
    expect(page).to have_content('Didática')
    
    # Quando eu clico no link "Exportar CSV" na linha do formulário
    within('.table') do
      within('tr', text: 'Didática') do
        click_link 'Exportar CSV'
      end
    end
    
    # Então eu devo permanecer na página de resultados
    expect(page).to have_current_path(admin_resultado_path(formulario))
    
    # E eu devo ver a mensagem de erro "Não foi possível gerar o arquivo de resultados."
    expect(page).to have_content("Não foi possível gerar o arquivo de resultados.")
  end
end
