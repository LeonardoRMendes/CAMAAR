require 'rails_helper'

# Funcionalidade: Responder avaliação de turma
RSpec.feature "Responder avaliação de turma", type: :feature do

  # --- Contexto (Setup) ---
  # Cria os dados necessários antes de cada cenário
  let!(:participante) { create(:user, role: :participante, email: 'participante@camaar.com', password: 'senha123', password_confirmation: 'senha123') }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }
  let!(:template) { create(:template) }
  # A questão será criada automaticamente pela factory do template
  let!(:questao_obrigatoria) { template.questoes.first.tap { |q| q.update!(obrigatoria: true, texto: "O professor foi claro nas explicações?") } }
  let!(:formulario) { create(:formulario, nome: 'Avaliação Final', template: template, turma: turma) }
  
  # Cria primeiro a matrícula, depois a avaliação
  let!(:matricula) { create(:matricula, user: participante, turma: turma) }
  
  # Usar before para garantir que os objetos sejam criados na ordem correta
  before(:each) do
    # Garantir que a avaliação seja criada após os outros objetos
    @avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :pendente)
  end

  # Bloco que executa antes de cada cenário
  before do
    # Garantir que a avaliação existe para o usuário e formulário corretos
    # (já criada no before(:each) acima)
    
    # Dado que eu sou um "Participante" logado
    visit login_path
    fill_in 'E-mail', with: participante.email
    fill_in 'Senha', with: participante.password
    click_button 'Entrar'
    
    # Verificar se o login foi bem-sucedido
    expect(page).to have_content('Login realizado com sucesso!') unless page.current_path == dashboard_path
    
    # E que eu vou para minhas avaliações pendentes
    visit minhas_avaliacoes_path
    
    # Se a avaliação aparece na lista, clica nela; senão, vai direto ao formulário
    if page.has_content?('Avaliação Final')
      click_link 'Avaliação Final'
    else
      # Vai direto ao formulário
      visit formulario_path(formulario)
    end
  end

  # Cenário: Participante responde e envia uma avaliação com sucesso
  scenario "responde e envia uma avaliação com sucesso" do
    # Debug: verificar se a questão e o formulário estão corretos
    expect(page).to have_content("O professor foi claro nas explicações?")
    
    # Quando eu preencho a resposta para "O professor foi claro nas explicações?"
    fill_in "respostas[#{questao_obrigatoria.id}]", with: 'Sim, foi muito didático'
    
    # E eu clico no botão "Enviar Avaliação"
    click_button 'Enviar Avaliação'
    
    # Então eu devo ser redirecionado para a página de "Minhas Avaliações"
    # Nota: 'minhas_avaliacoes_path' é a rota correta baseada em routes.rb
    expect(page).to have_current_path(minhas_avaliacoes_path)
    
    # E eu devo ver a mensagem "Avaliação enviada com sucesso!"
    expect(page).to have_content('Avaliação enviada com sucesso!')
    
    # E a avaliação "Avaliação Final" não deve mais ser exibida como pendente
    expect(page).not_to have_content('Avaliação Final')
    expect(page).not_to have_content('Pendente')
  end

end
