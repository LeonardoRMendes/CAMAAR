require 'rails_helper'

RSpec.feature "Visualizar Formulários para Responder", type: :feature do

  let!(:participante) { create(:user, email: 'participante@unb.br', password: 'senha123') }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }

  before do
    turma.users << participante

    visit login_path
    fill_in 'E-mail', with: 'participante@unb.br'
    fill_in 'Senha', with: 'senha123'
    click_button 'Entrar'
    
    visit avaliacoes_path
  end

  scenario "visualiza avaliações pendentes" do
    formulario = create(:formulario, nome: 'Avaliação de Meio de Semestre', turma: turma)
    create(:avaliacao, formulario: formulario, user: participante, status: :pendente)
    
    visit current_path

    within(".turma-card", text: "Cálculo 1") do
      expect(page).to have_link('Avaliação de Meio de Semestre')
    end
  end

  scenario "não possui avaliações pendentes em uma turma" do
    formulario = create(:formulario, nome: 'Avaliação Concluída', turma: turma)
    avaliacao = create(:avaliacao, user: participante, formulario: formulario, status: :concluida)
    
    visit avaliacoes_path
    
    expect(page).to have_content("Você não possui avaliações pendentes no momento.")
  end
end
