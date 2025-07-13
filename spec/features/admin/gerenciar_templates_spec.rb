require 'rails_helper'

# Funcionalidade: Gerenciamento de Templates de Formulário
RSpec.feature "Gerenciamento de Templates de Formulário", type: :feature do

  # --- Contexto (Setup) ---
  # Cria o usuário administrador antes de todos os cenários
  let!(:admin) { create(:user, role: :admin) }

  # Bloco que executa antes de cada cenário para logar o admin
  before do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: 'password123'
    click_button 'Entrar'
  end

  # Cenário: Administrador cria um novo template com sucesso
  scenario "cria um novo template com sucesso" do
    # Quando eu vou para a página de "Gerenciamento de Templates"
    visit admin_templates_path
    
    # E eu clico no botão "Criar Novo Template"
    click_link 'Criar Novo Template' # Usando 'click_link' se for um link, ou 'click_button'
    
    # E eu preencho o campo "Nome do Template" com "Feedback Padrão Semestral"
    fill_in 'Nome do Template', with: 'Feedback Padrão Semestral'
    
    # E eu adiciono a questão "Qual o seu nível de satisfação com a didática?"
    # Nota: A implementação de adicionar questões pode variar (ex: campos aninhados, JavaScript).
    # Este é um exemplo para um formulário simples.
    fill_in 'template_questoes_attributes_0_texto', with: 'Qual o seu nível de satisfação com a didática?'
    
    # E eu clico no botão "Salvar Template"
    click_button 'Salvar Template'
    
    # Então eu devo ver a mensagem "Template 'Feedback Padrão Semestral' criado com sucesso"
    expect(page).to have_content("Template 'Feedback Padrão Semestral' criado com sucesso")
    
    # E eu devo ver "Feedback Padrão Semestral" na lista de templates
    expect(page).to have_content('Feedback Padrão Semestral')
  end

  # Cenário: Tentativa de criar um template sem nome
  scenario "tenta criar um template sem nome" do
    visit new_admin_template_path
    click_button 'Salvar Template'
    expect(page).to have_content("O template deve ter um nome")
  end

  # Cenário: Tentativa de criar um template sem questões
  scenario "tenta criar um template sem questões" do
    visit new_admin_template_path
    fill_in 'Nome do Template', with: 'Template Vazio'
    click_button 'Salvar Template'
    expect(page).to have_content("O template deve ter pelo menos uma questão")
  end

  # Cenário: Administrador edita o nome de um template com sucesso
  scenario "edita o nome de um template com sucesso" do
    # Dado que existe um template com o nome "Feedback Padrao Semestral"
    template = create(:template, nome: 'Feedback Padrao Semestral')
    
    # Quando eu vou para a página de "Gerenciamento de Templates"
    visit admin_templates_path
    
    # E eu clico em "Editar" para o template "Feedback Padrao Semestral"
    # Busca o link de edição dentro da linha da tabela correspondente ao template
    find("tr", text: 'Feedback Padrao Semestral').click_link 'Editar'
    
    # E eu preencho o campo "Nome do Template" com "Feedback Padrão 2025"
    fill_in 'Nome do Template', with: 'Feedback Padrão 2025'
    
    # E eu clico no botão "Salvar Template"
    click_button 'Salvar Template'
    
    # Então eu devo ver a mensagem "Template 'Feedback Padrão 2025' atualizado com sucesso"
    expect(page).to have_content("Template 'Feedback Padrão 2025' atualizado com sucesso")
    
    # E eu devo ver "Feedback Padrão 2025" na lista de templates
    expect(page).to have_content('Feedback Padrão 2025')
    
    # E eu não devo mais ver "Feedback Padrao Semestral" na lista
    expect(page).not_to have_content('Feedback Padrao Semestral')
  end

  # Cenário: Administrador exclui um template não utilizado com sucesso
  scenario "exclui um template não utilizado com sucesso" do
    # Dado que existe um template com o nome "Template Temporário"
    create(:template, nome: 'Template Temporário')
    
    visit admin_templates_path
    
    # E eu clico em "Excluir" para o template "Template Temporário"
    # Aceita a caixa de diálogo de confirmação do navegador
    accept_confirm do
      find("tr", text: 'Template Temporário').click_link 'Excluir'
    end
    
    # Então eu devo ver a mensagem "Template 'Template Temporário' foi excluído com sucesso."
    expect(page).to have_content("Template 'Template Temporário' foi excluído com sucesso.")
    
    # E eu não devo mais ver "Template Temporário" na lista de templates
    expect(page).not_to have_content('Template Temporário')
  end

  # Cenário: Administrador não consegue excluir um template que já foi usado
  scenario "não consegue excluir um template que já foi usado" do
    # Dado que o template "Relatório Anual" já foi usado para criar um formulário
    template_usado = create(:template, nome: 'Relatório Anual')
    create(:formulario, template: template_usado)
    
    visit admin_templates_path
    
    # E eu clico em "Excluir" para o template "Relatório Anual"
    accept_confirm do
      find("tr", text: 'Relatório Anual').click_link 'Excluir'
    end
    
    # Então eu devo ver a mensagem de erro "Não é possível excluir o template 'Relatório Anual', pois ele já foi utilizado em formulários."
    expect(page).to have_content("Não é possível excluir o template 'Relatório Anual', pois ele já foi utilizado em formulários.")
    
    # E eu ainda devo ver "Relatório Anual" na lista de templates
    expect(page).to have_content('Relatório Anual')
  end
end
