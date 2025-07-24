require 'rails_helper'

RSpec.feature "Exportar Relatórios de Resultados", type: :feature do

  let!(:admin) { create(:user, role: :admin, email: 'admin@camaar.com', password: 'password123', password_confirmation: 'password123') }
  let!(:participante) { create(:user, role: :participante, email: 'participante@camaar.com', password: 'password123', password_confirmation: 'password123') }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }
  let!(:template) { create(:template) }
  let!(:questao) { create(:questao, template: template, texto: "Como você avalia a didática do professor?") }
  let!(:formulario) { create(:formulario, nome: 'Didática', template: template, turma: turma) }
  
  before do
    turma.users << participante
    
    avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :concluida)
    create(:resposta, avaliacao: avaliacao, questao: questao, conteudo: 'Excelente')

    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: admin.password
    click_button 'Entrar'

    visit admin_resultados_path
  end

  scenario "Exportar resultados para CSV com sucesso" do
    expect(page).to have_content('Didática')
    
    within('.table') do
      within('tr', text: 'Didática') do
        click_link 'Exportar CSV'
      end
    end
    
    expect(page.response_headers['Content-Disposition']).to include("filename=\"didatica_resultados.csv\"")
    expect(page.response_headers['Content-Type']).to eq('text/csv')
    
    expect(page.body).to include("Questão,Resposta,Votos")
    
    expect(page.body).to include("Como você avalia a didática do professor?,Excelente,1")
  end

  scenario "Falha na geração do arquivo CSV" do
    allow_any_instance_of(CsvExportService).to receive(:generate).and_raise(StandardError.new("Erro de Geração"))
    
    expect(page).to have_content('Didática')
    
    within('.table') do
      within('tr', text: 'Didática') do
        click_link 'Exportar CSV'
      end
    end
    
    expect(page).to have_current_path(admin_resultado_path(formulario))
    
    expect(page).to have_content("Não foi possível gerar o arquivo de resultados.")
  end
end
