require 'rails_helper'

RSpec.feature "Visualização de Resultados dos Formulários", type: :feature do

  let!(:admin) { create(:user, role: :admin, email: 'admin@camaar.com', password: 'password123', password_confirmation: 'password123') }

  before do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: admin.password
    click_button 'Entrar'
  end

  scenario "visualizar resultados de um formulário com uma resposta" do
    turma = create(:turma, nome: 'Cálculo 1')
    template = create(:template)
    questao = create(:questao, template: template, texto: "Como você avalia a didática do professor?")
    formulario = create(:formulario, nome: 'Didática', template: template, turma: turma)
    participante = create(:user, role: :participante)
    turma.users << participante
    avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :concluida)
    create(:resposta, avaliacao: avaliacao, questao: questao, conteudo: 'Excelente')

    visit admin_resultados_path
    
    expect(page).to have_content('Didática')
    
    within('.table') do
      within('tr', text: 'Didática') do
        click_link 'Ver Resultados'
      end
    end
    
    expect(page).to have_content("Como você avalia a didática do professor?")
    
    within(".questao-results", text: "Como você avalia a didática do professor?") do
      expect(page).to have_content("Excelente")
      expect(page).to have_content("1 voto")
    end
  end

  scenario "visualizar um formulário sem respostas" do
    turma = create(:turma, nome: 'História')
    template = create(:template)
    create(:formulario, nome: 'Metodologia de Ensino', template: template, turma: turma)
    
    visit admin_resultados_path
    
    expect(page).to have_content('Metodologia de Ensino')
    
    within('.table') do
      within('tr', text: 'Metodologia de Ensino') do
        click_link 'Ver Resultados'
      end
    end
    
    expect(page).to have_content("Este formulário ainda não possui respostas.")
  end
end
