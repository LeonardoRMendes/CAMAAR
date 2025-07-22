require 'rails_helper'

RSpec.feature "Responder avaliação de turma", type: :feature do

  let!(:participante) { create(:user, role: :participante, email: 'participante@camaar.com', password: 'senha123', password_confirmation: 'senha123') }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }
  let!(:template) { create(:template) }
  let!(:questao_obrigatoria) { template.questoes.first.tap { |q| q.update!(obrigatoria: true, texto: "O professor foi claro nas explicações?") } }
  let!(:formulario) { create(:formulario, nome: 'Avaliação Final', template: template, turma: turma) }
  
  let!(:matricula) { create(:matricula, user: participante, turma: turma) }
  
  before(:each) do
    @avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :pendente)
  end

  before do
    visit login_path
    fill_in 'E-mail', with: participante.email
    fill_in 'Senha', with: participante.password
    click_button 'Entrar'
    
    expect(page).to have_content('Login realizado com sucesso!') unless page.current_path == dashboard_path
    
    visit minhas_avaliacoes_path
    
    if page.has_content?('Avaliação Final')
      click_link 'Avaliação Final'
    else
      visit formulario_path(formulario)
    end
  end

  scenario "responde e envia uma avaliação com sucesso" do
    expect(page).to have_content("O professor foi claro nas explicações?")
    
    fill_in "respostas[#{questao_obrigatoria.id}]", with: 'Sim, foi muito didático'
    
    click_button 'Enviar Avaliação'
    
    expect(page).to have_current_path(minhas_avaliacoes_path)
    
    expect(page).to have_content('Avaliação enviada com sucesso!')
    
    expect(page).not_to have_content('Avaliação Final')
    expect(page).not_to have_content('Pendente')
  end

end
