require 'rails_helper'

# Funcionalidade: Visualização de Resultados dos Formulários
RSpec.feature "Visualização de Resultados dos Formulários", type: :feature do

  # --- Contexto (Setup) ---
  let!(:admin) { create(:user, role: :admin, email: 'admin@camaar.com', password: 'password123', password_confirmation: 'password123') }

  # Bloco que executa antes de cada cenário para logar o admin
  before do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: admin.password
    click_button 'Entrar'
  end

  # Cenário: Visualizar resultados de um formulário com uma resposta
  scenario "visualizar resultados de um formulário com uma resposta" do
    # Dado que um formulário sobre "Didática" foi respondido...
    turma = create(:turma, nome: 'Cálculo 1')
    template = create(:template)
    questao = create(:questao, template: template, texto: "Como você avalia a didática do professor?")
    formulario = create(:formulario, nome: 'Didática', template: template, turma: turma)
    participante = create(:user, role: :participante)
    turma.users << participante
    avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :concluida)
    create(:resposta, avaliacao: avaliacao, questao: questao, conteudo: 'Excelente')

    # Quando eu vou para a página de "Resultados"
    visit admin_resultados_path
    
    # E eu clico para ver os resultados do formulário "Didática"
    # Busca o link de resultados dentro da linha da tabela correspondente ao formulário
    expect(page).to have_content('Didática')
    
    within('.table') do
      within('tr', text: 'Didática') do
        click_link 'Ver Resultados'
      end
    end
    
    # Então eu devo ver o título da questão "Como você avalia a didática do professor?"
    expect(page).to have_content("Como você avalia a didática do professor?")
    
    # E eu devo ver a resposta "Excelente" com a contagem de "1 voto"
    # Verifica dentro de um elemento específico para garantir o contexto correto
    within(".questao-results", text: "Como você avalia a didática do professor?") do
      expect(page).to have_content("Excelente")
      expect(page).to have_content("1 voto")
    end
  end

  # Cenário: Visualizar um formulário sem respostas
  scenario "visualizar um formulário sem respostas" do
    # Dado que o formulário "Metodologia de Ensino" foi criado mas não foi respondido
    turma = create(:turma, nome: 'História')
    template = create(:template)
    create(:formulario, nome: 'Metodologia de Ensino', template: template, turma: turma)
    
    # Quando eu vou para a página de "Resultados"
    visit admin_resultados_path
    
    # E eu clico para ver os resultados do formulário "Metodologia de Ensino"
    expect(page).to have_content('Metodologia de Ensino')
    
    within('.table') do
      within('tr', text: 'Metodologia de Ensino') do
        click_link 'Ver Resultados'
      end
    end
    
    # Então eu devo ver a mensagem "Este formulário ainda não possui respostas."
    expect(page).to have_content("Este formulário ainda não possui respostas.")
  end
end
