require 'rails_helper'

RSpec.feature "Criar Formulário de Avaliação", type: :feature do

  let!(:admin) { create(:user, role: :admin, email: 'admin@camaar.com', password: 'password123', password_confirmation: 'password123') }
  let!(:participante) { create(:user, role: :participante, email: 'aluno@camaar.com', password: 'password123', password_confirmation: 'password123') }
  let!(:template) { create(:template, nome: 'Feedback Padrão Semestral') }
  let!(:turma_calculo) { create(:turma, :calculo) }
  let!(:turma_fisica) { create(:turma, :fisica) }

  before do
    turma_calculo.users << participante
  end
  
  before(:each) do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: 'password123'
    click_button 'Entrar'

    visit admin_formularios_path 

    click_link 'Criar Novo Formulário'
  end

  scenario "cria e envia um formulário para uma turma com sucesso" do
    select 'Feedback Padrão Semestral', from: 'template_id'
    
    check 'Cálculo 1'
    
    click_button 'Gerar Formulário'
    
    expect(page).to have_content("Formulário 'Feedback Padrão Semestral' foi gerado e enviado para 1 turma(s).")
    
    participante.reload 
    expect(participante.avaliacoes.pendente.count).to eq(1)
    expect(participante.avaliacoes.first.formulario.template).to eq(template)
  end

  scenario "tenta gerar um formulário sem selecionar um template" do
    check 'Cálculo 1'
    
    click_button 'Gerar Formulário'
    
    expect(page).to have_current_path(admin_formularios_path) 
    
    expect(page).to have_content("É necessário selecionar um template.")
  end

  scenario "tenta gerar um formulário sem selecionar uma turma" do
    select 'Feedback Padrão Semestral', from: 'template_id'
    
    click_button 'Gerar Formulário'
    
    expect(page).to have_current_path(admin_formularios_path)
    
    expect(page).to have_content("É necessário selecionar pelo menos uma turma.")
  end
end
