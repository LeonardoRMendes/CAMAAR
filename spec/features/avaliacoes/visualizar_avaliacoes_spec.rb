require 'rails_helper'

# Funcionalidade: Visualizar Formulários para Responder
RSpec.feature "Visualizar Formulários para Responder", type: :feature do

  # --- Contexto (Setup) ---
  # Cria os dados base que serão usados em ambos os cenários
  let!(:participante) { create(:user, email: 'participante@unb.br', password: 'senha123') }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }

  # Bloco que executa antes de cada cenário
  before do
    # E que eu estou matriculado na turma "Cálculo 1"
    turma.users << participante

    # Quando eu faço login
    visit login_path
    fill_in 'E-mail', with: 'participante@unb.br'
    fill_in 'Senha', with: 'senha123'
    click_button 'Entrar'
    
    # E eu vou para a página "Minhas Avaliações"
    # Nota: a rota 'avaliacoes_path' é uma suposição. Altere se necessário.
    visit avaliacoes_path
  end

  # Cenário: Participante visualiza avaliações pendentes
  scenario "visualiza avaliações pendentes" do
    # Dado que a turma "Cálculo 1" possui o formulário "Avaliação de Meio de Semestre"
    formulario = create(:formulario, nome: 'Avaliação de Meio de Semestre', turma: turma)
    create(:avaliacao, formulario: formulario, user: participante, status: :pendente)
    
    # Recarrega a página para refletir os novos dados criados no cenário
    visit current_path

    # Então eu devo ver o card da turma "Cálculo 1"
    # Usamos within para garantir que as próximas verificações ocorram dentro do card correto
    within(".card", text: "Cálculo 1") do
      # E dentro do card da turma, eu devo ver o link para a avaliação "Avaliação de Meio de Semestre"
      expect(page).to have_link('Avaliação de Meio de Semestre')
    end
  end

  # Cenário: Participante não possui avaliações pendentes em uma turma
  scenario "não possui avaliações pendentes em uma turma" do
    # Dado que a turma "Cálculo 1" não possui formulários pendentes para mim
    # (Nenhum dado extra é criado neste cenário)
    
    # Então eu devo ver o card da turma "Cálculo 1"
    within(".card", text: "Cálculo 1") do
      # E dentro do card da turma, eu devo ver a mensagem "Todos os formulários dessa turma foram respondidos."
      expect(page).to have_content("Todos os formulários dessa turma foram respondidos.")
      
      # Garante também que não há links de avaliação
      expect(page).not_to have_link('Responder') 
    end
  end
end
