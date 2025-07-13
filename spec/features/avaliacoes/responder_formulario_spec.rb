require 'rails_helper'

# Funcionalidade: Responder avaliação de turma
RSpec.feature "Responder avaliação de turma", type: :feature do

  # --- Contexto (Setup) ---
  # Cria os dados necessários antes de cada cenário
  let!(:participante) { create(:user, role: :participante) }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }
  let!(:template) { create(:template) }
  let!(:questao_obrigatoria) { create(:questao, template: template, texto: "O professor foi claro nas explicações?", obrigatoria: true) }
  let!(:formulario) { create(:formulario, nome: 'Avaliação Final', template: template, turma: turma) }
  let!(:avaliacao) { create(:avaliacao, formulario: formulario, user: participante, status: :pendente) }

  # Bloco que executa antes de cada cenário
  before do
    # Dado que eu sou um "Participante" logado
    visit login_path
    fill_in 'E-mail', with: participante.email
    fill_in 'Senha', with: 'password123'
    click_button 'Entrar'
    
    # E que eu estou na página de resposta do formulário "Avaliação Final"
    # Nota: a rota 'edit_avaliacao_path' é uma suposição. Altere se necessário.
    visit edit_avaliacao_path(avaliacao)
  end

  # Cenário: Participante responde e envia uma avaliação com sucesso
  scenario "responde e envia uma avaliação com sucesso" do
    # Quando eu preencho a resposta para "O professor foi claro nas explicações?"
    # Nota: 'resposta_conteudo' é um nome de campo suposto. Altere para o ID/name/label real.
    fill_in 'resposta_conteudo', with: 'Sim, foi muito didático'
    
    # E eu clico no botão "Enviar Avaliação"
    click_button 'Enviar Avaliação'
    
    # Então eu devo ser redirecionado para a página de "Minhas Avaliações"
    # Nota: 'avaliacoes_path' é uma suposição. Altere se necessário.
    expect(page).to have_current_path(avaliacoes_path)
    
    # E eu devo ver a mensagem "Avaliação enviada com sucesso!"
    expect(page).to have_content('Avaliação enviada com sucesso!')
    
    # E a avaliação "Avaliação Final" não deve mais ser exibida como pendente
    expect(page).not_to have_content('Avaliação Final')
    expect(page).not_to have_content('Pendente')
  end

  # Cenário: Participante tenta enviar uma avaliação com campos obrigatórios em branco
  scenario "tenta enviar uma avaliação com campos obrigatórios em branco" do
    # Quando eu clico no botão "Enviar Avaliação" sem preencher os campos obrigatórios
    click_button 'Enviar Avaliação'
    
    # Então eu devo permanecer na página de resposta da avaliação
    expect(page).to have_current_path(edit_avaliacao_path(avaliacao))
    
    # E eu devo ver a mensagem de erro "Todos os campos obrigatórios devem ser preenchidos"
    expect(page).to have_content('Todos os campos obrigatórios devem ser preenchidos')
  end
end
