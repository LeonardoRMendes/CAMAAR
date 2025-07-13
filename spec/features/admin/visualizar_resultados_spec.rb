require 'rails_helper'

# Funcionalidade: Visualização de Resultados dos Formulários
RSpec.feature "Visualização de Resultados dos Formulários", type: :feature do

  # --- Contexto (Setup) ---
  let!(:admin) { create(:user, role: :admin) }

  # Bloco que executa antes de cada cenário para logar o admin
  before do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: 'password123'
    click_button 'Entrar'
  end

  # Cenário: Visualizar resultados de um formulário com uma resposta
  scenario "visualizar resultados de um formulário com uma resposta" do
    # Dado que um formulário sobre "Didática" foi respondido...
    template = create(:template)
    questao = create(:questao, template: template, texto: "Como você avalia a didática do professor?")
    formulario = create(:formulario, nome: 'Didática', template: template)
    participante = create(:user, role: :participante)
    avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :concluida)
    create(:resposta, avaliacao: avaliacao, questao: questao, conteudo: 'Excelente')

    # Quando eu vou para a página de "Resultados"
    # Nota: A rota 'admin_formularios_path' é uma suposição para a listagem. Altere se necessário.
    visit admin_formularios_path
    
    # E eu clico para ver os resultados do formulário "Didática"
    # Busca o link de resultados dentro da linha da tabela correspondente ao formulário
    find("tr", text: 'Didática').click_link 'Ver Resultados'
    
    # Então eu devo ver o título da questão "Como você avalia a didática do professor?"
    expect(page).to have_content("Como você avalia a didática do professor?")
    
    # E eu devo ver a resposta "Excelente" com a contagem de "1 voto"
    # Verifica dentro de um elemento específico para garantir o contexto correto
    within(".resultado-questao", text: "Como você avalia a didática do professor?") do
      expect(page).to have_content("Excelente")
      expect(page).to have_content("1 voto")
    end
  end

  # Cenário: Visualizar um formulário sem respostas
  scenario "visualizar um formulário sem respostas" do
    # Dado que o formulário "Metodologia de Ensino" foi criado mas não foi respondido
    create(:formulario, nome: 'Metodologia de Ensino')
    
    # Quando eu vou para a página de "Resultados"
    visit admin_formularios_path
    
    # E eu clico para ver os resultados do formulário "Metodologia de Ensino"
    find("tr", text: 'Metodologia de Ensino').click_link 'Ver Resultados'
    
    # Então eu devo ver a mensagem "Este formulário ainda não possui respostas."
    expect(page).to have_content("Este formulário ainda não possui respostas.")
  end
end
