require 'rails_helper'

# Funcionalidade: Criar Formulário de Avaliação a partir de um Template
RSpec.feature "Criar Formulário de Avaliação", type: :feature do

  # --- Contexto (Setup) ---
  # Cria os dados necessários antes de cada cenário
  let!(:admin) { create(:user, role: :admin, email: 'admin@camaar.com', password: 'password123') }
  let!(:participante) { create(:user, role: :participante, email: 'aluno@camaar.com', password: 'password123') }
  let!(:template) { create(:template, nome: 'Feedback Padrão Semestral') }
  let!(:turma_calculo) { create(:turma, nome: 'Cálculo 1') }
  let!(:turma_fisica) { create(:turma, nome: 'Física 1') }

  # Matricula o participante na turma de Cálculo para o teste de sucesso
  before do
    turma_calculo.users << participante
  end
  
  # Bloco que executa antes de cada cenário para logar o admin e navegar para a página
  before(:each) do
    # Dado que eu sou um "Administrador" logado
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: 'password123'
    click_button 'Entrar'

    # E eu vou para a página de "Gerenciamento de Formulários"
    # Nota: a rota 'admin_formularios_path' é uma suposição. Altere se necessário.
    visit admin_formularios_path 

    # E eu clico em "Criar Novo Formulário"
    click_button 'Criar Novo Formulário'
  end

  # Cenário: Administrador cria e envia um formulário para uma turma com sucesso
  scenario "cria e envia um formulário para uma turma com sucesso" do
    # Quando eu seleciono o template "Feedback Padrão Semestral"
    # Nota: 'template_id' é uma suposição para o nome do campo select. Altere se necessário.
    select 'Feedback Padrão Semestral', from: 'template_id'
    
    # E eu seleciono a turma "Cálculo 1"
    # Nota: 'turma_ids[]' é uma suposição para o nome dos checkboxes. Altere se necessário.
    check 'Cálculo 1'
    
    # E eu clico no botão "Gerar Formulário"
    click_button 'Gerar Formulário'
    
    # Então eu devo ver a mensagem "Formulário 'Feedback Padrão Semestral' foi gerado e enviado para 1 turma(s)."
    expect(page).to have_content("Formulário 'Feedback Padrão Semestral' foi gerado e enviado para 1 turma(s).")
    
    # E o participante "aluno@camaar.com" matriculado na turma "Cálculo 1" deve ter uma avaliação pendente
    # Recarrega o objeto 'participante' para pegar as associações mais recentes do banco
    participante.reload 
    expect(participante.avaliacoes.pendente.count).to eq(1)
    expect(participante.avaliacoes.first.formulario.template).to eq(template)
  end

  # Cenário: Tentativa de gerar um formulário sem selecionar um template
  scenario "tenta gerar um formulário sem selecionar um template" do
    # Quando eu seleciono a turma "Cálculo 1"
    check 'Cálculo 1'
    
    # E eu clico no botão "Gerar Formulário"
    click_button 'Gerar Formulário'
    
    # Então eu devo permanecer na página de criação de formulário
    # Nota: 'new_admin_formulario_path' é uma suposição. Altere se necessário.
    expect(page).to have_current_path(new_admin_formulario_path) 
    
    # E eu devo ver a mensagem de erro "É necessário selecionar um template."
    expect(page).to have_content("É necessário selecionar um template.")
  end

  # Cenário: Tentativa de gerar um formulário sem selecionar uma turma
  scenario "tenta gerar um formulário sem selecionar uma turma" do
    # Quando eu seleciono o template "Feedback Padrão Semestral"
    select 'Feedback Padrão Semestral', from: 'template_id'
    
    # E eu clico no botão "Gerar Formulário"
    click_button 'Gerar Formulário'
    
    # Então eu devo permanecer na página de criação de formulário
    expect(page).to have_current_path(new_admin_formulario_path)
    
    # E eu devo ver a mensagem de erro "É necessário selecionar pelo menos uma turma."
    expect(page).to have_content("É necessário selecionar pelo menos uma turma.")
  end
end
