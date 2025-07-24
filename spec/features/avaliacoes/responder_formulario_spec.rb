require 'rails_helper'

RSpec.feature "Responder avaliação de turma", type: :feature do

  let!(:participante) { create(:user, role: :participante, email: 'participante@camaar.com', password: 'senha123', password_confirmation: 'senha123') }
  let!(:turma) { create(:turma, nome: 'Cálculo 1') }
  let!(:template) { create(:template) }
  let!(:questao_obrigatoria) { template.questoes.first.tap { |q| q.update!(obrigatoria: true, texto: "O professor foi claro nas explicações?") } }
  let!(:formulario) { create(:formulario, nome: 'Avaliação Final', template: template, turma: turma) }
  let!(:matricula) { create(:matricula, user: participante, turma: turma) }

  before do
    visit login_path
    fill_in 'E-mail', with: participante.email
    fill_in 'Senha', with: participante.password
    click_button 'Entrar'

    visit minhas_avaliacoes_path
    if page.has_content?('Avaliação Final')
      click_link 'Avaliação Final'
    else
      visit formulario_path(formulario)
    end
  end

  context "com avaliação pré-existente" do
    before(:each) do
      @avaliacao = create(:avaliacao, formulario: formulario, user: participante, status: :pendente)
    end

    scenario "responde e envia uma avaliação com sucesso" do
      fill_in "respostas[#{questao_obrigatoria.id}]", with: 'Sim, foi muito didático'
      click_button 'Enviar Avaliação'

      expect(page).to have_current_path(minhas_avaliacoes_path)
      expect(page).to have_content('Avaliação enviada com sucesso!')
    end

    scenario "não preenche campo obrigatório e recebe erro" do
      click_button 'Enviar Avaliação'

      expect(page).to have_content('Todos os campos obrigatórios devem ser preenchidos')
      expect(page).to have_content("O professor foi claro nas explicações?")
    end

    scenario "avaliação já concluída redireciona com aviso" do
      @avaliacao.update!(status: :concluida)

      fill_in "respostas[#{questao_obrigatoria.id}]", with: 'Resposta'
      click_button 'Enviar Avaliação'

      expect(page).to have_current_path(minhas_avaliacoes_path)
      expect(page).to have_content('Esta avaliação já foi concluída.')
    end

    scenario "atualiza uma resposta já existente" do
      create(:resposta, questao: questao_obrigatoria, avaliacao: @avaliacao, user: participante, conteudo: "Antigo conteúdo")

      fill_in "respostas[#{questao_obrigatoria.id}]", with: 'Nova resposta'
      click_button 'Enviar Avaliação'

      expect(Resposta.last.conteudo).to eq('Nova resposta')
    end
  end

  context "sem avaliação prévia" do
    before do
      Avaliacao.destroy_all
    end

    scenario "cria avaliação se estiver matriculado e envia com sucesso" do
      fill_in "respostas[#{questao_obrigatoria.id}]", with: 'Tudo certo'

      expect {
        click_button 'Enviar Avaliação'
      }.to change { Avaliacao.count }.by(1)

      expect(page).to have_content('Avaliação enviada com sucesso!')
    end

    scenario "não permite enviar se não estiver matriculado" do
      Matricula.destroy_all

      fill_in "respostas[#{questao_obrigatoria.id}]", with: 'Resposta'
      click_button 'Enviar Avaliação'

      expect(page).to have_content('Você não está matriculado nesta turma.')
      expect(page).to have_content("O professor foi claro nas explicações?")
    end
  end
end
