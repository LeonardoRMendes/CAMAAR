require 'rails_helper'

RSpec.feature "Importação de Dados via Arquivo JSON", type: :feature do

  let!(:admin) { create(:user, role: :admin, email: 'admin@camaar.com', password: 'password123', password_confirmation: 'password123') }

  before(:all) do
    @fixtures_path = Rails.root.join('spec', 'fixtures', 'files')
    FileUtils.mkdir_p(@fixtures_path)
  end

  after(:all) do
    FileUtils.rm_rf(@fixtures_path)
  end

  before do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: admin.password
    click_button 'Entrar'
    
    visit admin_importacoes_path
  end

  scenario "Importação de um arquivo JSON bem-sucedida" do
    json_content = '{
      "turmas": [
        {
          "id_turma": "123",
          "codigo_componente": "COMP123",
          "nome_componente": "Engenharia de Software",
          "ano": 2024,
          "periodo": 1,
          "discentes": ["12345"]
        }
      ],
      "discentes": [
        {
          "matricula": "12345",
          "nome": "Joao Silva",
          "email": "joao.silva@email.com"
        }
      ]
    }'
    File.write(File.join(@fixtures_path, 'class_members.json'), json_content)
    
    attach_file 'arquivo', File.join(@fixtures_path, 'class_members.json')
    
    click_button 'Importar Arquivo'
    
    expect(page).to have_content('Arquivo importado com sucesso!')
    
    expect(User.find_by(email: 'joao.silva@email.com')).to be_present
    
    expect(Turma.find_by(codigo: 'COMP123')).to be_present
  end

  scenario "Tentativa de importar um arquivo com formato inválido" do
    File.write(File.join(@fixtures_path, 'invalido.json'), "{'formato': 'invalido'}")
    
    attach_file 'arquivo', File.join(@fixtures_path, 'invalido.json')
    
    click_button 'Importar Arquivo'
    
    expect(page).to have_content('Ocorreu um erro ao processar o arquivo. Verifique o formato do JSON.')
  end

  scenario "Importação não duplica usuários ou turmas existentes" do
    turma_existente = create(:turma, codigo: 'COMP123', nome: 'COMP123 - Engenharia de Software', sigaa_id: '123')
    create(:user, email: 'joao.silva@email.com', nome: 'Joao Silva', role: :participante, matricula: '12345')

    json_content = '{
      "turmas": [
        {
          "id_turma": "123",
          "codigo_componente": "COMP123",
          "nome_componente": "Engenharia de Software",
          "ano": 2024,
          "periodo": 1,
          "discentes": ["12345"]
        }
      ],
      "discentes": [
        {
          "matricula": "12345",
          "nome": "Joao Silva",
          "email": "joao.silva@email.com"
        }
      ]
    }'
    File.write(File.join(@fixtures_path, 'class_members.json'), json_content)
    
    attach_file 'arquivo', File.join(@fixtures_path, 'class_members.json')
    
    click_button 'Importar Arquivo'
    
    expect(page).to have_content('0 novos participantes e 0 novas turmas foram adicionados')
  end
end
