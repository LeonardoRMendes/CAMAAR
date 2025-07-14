require 'rails_helper'

RSpec.feature "Gerenciamento de Templates de Formulário", type: :feature do

  let!(:admin) { create(:user, :admin) }

  before do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: 'senha123'
    click_button 'Entrar'
  end

  scenario "cria um novo template com sucesso" do
    visit admin_templates_path
    
    click_link 'Criar Novo Template'
    
    fill_in 'Nome do Template', with: 'Feedback Padrão Semestral'
    
    fill_in 'questoes[][texto]', with: 'Qual o seu nível de satisfação com a didática?'
    
    click_button 'Salvar Template'
    
    expect(page).to have_content("Template 'Feedback Padrão Semestral' criado com sucesso")
    
    expect(page).to have_content('Feedback Padrão Semestral')
  end

  scenario "tenta criar um template sem nome" do
    visit new_admin_template_path
    click_button 'Salvar Template'
    expect(page).to have_content("O template deve ter um nome")
  end

  scenario "tenta criar um template sem questões" do
    visit new_admin_template_path
    fill_in 'Nome do Template', with: 'Template Vazio'
    click_button 'Salvar Template'
    expect(page).to have_content("O template deve ter pelo menos uma questão")
  end

  scenario "edita o nome de um template com sucesso" do
    template = create(:template, nome: 'Feedback Padrao Semestral')
    
    visit admin_templates_path
    
    find("tr", text: 'Feedback Padrao Semestral').click_link 'Editar'
    
    fill_in 'Nome do Template', with: 'Feedback Padrão 2025'
    
    click_button 'Salvar Template'
    
    expect(page).to have_content("Template 'Feedback Padrão 2025' atualizado com sucesso")
    
    expect(page).to have_content('Feedback Padrão 2025')
    
    expect(page).not_to have_content('Feedback Padrao Semestral')
  end

  scenario "exclui um template não utilizado com sucesso" do
    create(:template, nome: 'Template Temporário')
    
    visit admin_templates_path
    
    find("tr", text: 'Template Temporário').click_link 'Excluir'
    
    expect(page).to have_content("Template 'Template Temporário' foi excluído com sucesso.")
    
    if page.has_selector?('table tbody')
      within('table tbody') do
        expect(page).not_to have_content('Template Temporário')
      end
    else
      expect(page).to have_content('Nenhum template criado ainda.')
    end
  end

  scenario "não consegue excluir um template que já foi usado" do
    template_usado = create(:template, nome: 'Relatório Anual')
    create(:formulario, template: template_usado)
    
    visit admin_templates_path
    
    find("tr", text: 'Relatório Anual').click_link 'Excluir'
    
    expect(page).to have_content("Não é possível excluir o template 'Relatório Anual', pois ele já foi utilizado em formulários.")
    
    expect(page).to have_content('Relatório Anual')
  end
end
