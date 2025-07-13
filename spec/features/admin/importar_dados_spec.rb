require 'rails_helper'

# Funcionalidade: Importação de Dados via Arquivo JSON
RSpec.feature "Importação de Dados via Arquivo JSON", type: :feature do

  # --- Contexto (Setup) ---
  let!(:admin) { create(:user, role: :admin) }

  # Cria um diretório temporário para os arquivos de teste
  before(:all) do
    @fixtures_path = Rails.root.join('spec', 'fixtures', 'files')
    FileUtils.mkdir_p(@fixtures_path)
  end

  # Limpa o diretório temporário após todos os testes
  after(:all) do
    FileUtils.rm_rf(@fixtures_path)
  end

  # Bloco que executa antes de cada cenário para logar o admin
  before do
    visit login_path
    fill_in 'E-mail', with: admin.email
    fill_in 'Senha', with: 'password123'
    click_button 'Entrar'
    
    # E eu estou na página de "Importação de Dados"
    # Nota: a rota 'admin_importacao_path' é uma suposição. Altere se necessário.
    visit admin_importacao_path
  end

  # Cenário: Importação de um arquivo JSON bem-sucedida
  scenario "Importação de um arquivo JSON bem-sucedida" do
    # Cria um arquivo JSON válido para o teste
    json_content = '[{"turma": {"codigo": "COMP123", "nome": "Engenharia de Software"}, "discentes": [{"nome": "Joao Silva", "email": "joao.silva@email.com"}]}]'
    File.write(File.join(@fixtures_path, 'class_members.json'), json_content)
    
    # Quando eu anexo o arquivo "class_members.json"
    attach_file 'Arquivo JSON', File.join(@fixtures_path, 'class_members.json')
    
    # E eu clico no botão "Importar Arquivo"
    click_button 'Importar Arquivo'
    
    # Então eu devo ver uma mensagem de sucesso detalhando os dados importados
    expect(page).to have_content('Arquivo importado com sucesso!') # Ajuste a mensagem conforme sua implementação
    
    # E o usuário correspondente ao primeiro discente deve existir no banco de dados
    expect(User.find_by(email: 'joao.silva@email.com')).to be_present
    
    # E a turma correspondente à primeira turma deve existir no banco de dados
    expect(Turma.find_by(codigo: 'COMP123')).to be_present
  end

  # Cenário: Tentativa de importar um arquivo com formato inválido
  scenario "Tentativa de importar um arquivo com formato inválido" do
    # Dado que eu crio um arquivo de teste "invalido.json"
    File.write(File.join(@fixtures_path, 'invalido.json'), "{'formato': 'invalido'}")
    
    # Quando eu anexo o arquivo "invalido.json"
    attach_file 'Arquivo JSON', File.join(@fixtures_path, 'invalido.json')
    
    # E eu clico no botão "Importar Arquivo"
    click_button 'Importar Arquivo'
    
    # Então eu devo ver a mensagem de erro "Ocorreu um erro ao processar o arquivo. Verifique o formato do JSON."
    expect(page).to have_content('Ocorreu um erro ao processar o arquivo. Verifique o formato do JSON.')
  end

  # Cenário: Importação não duplica usuários ou turmas existentes
  scenario "Importação não duplica usuários ou turmas existentes" do
    # Dado que a primeira turma e o primeiro discente já existem no banco
    turma_existente = create(:turma, codigo: 'COMP123', nome: 'Engenharia de Software')
    create(:user, email: 'joao.silva@email.com', nome: 'Joao Silva')

    # Cria o mesmo arquivo JSON do primeiro teste
    json_content = '[{"turma": {"codigo": "COMP123", "nome": "Engenharia de Software"}, "discentes": [{"nome": "Joao Silva", "email": "joao.silva@email.com"}]}]'
    File.write(File.join(@fixtures_path, 'class_members.json'), json_content)
    
    # Quando eu anexo o arquivo "class_members.json"
    attach_file 'Arquivo JSON', File.join(@fixtures_path, 'class_members.json')
    
    # E eu clico no botão "Importar Arquivo"
    click_button 'Importar Arquivo'
    
    # Então a mensagem de sucesso deve indicar que "0 novos participantes e 0 novas turmas foram adicionados"
    # Nota: A mensagem exata pode variar. Ajuste conforme sua implementação.
    expect(page).to have_content('0 novos participantes e 0 novas turmas foram adicionados')
  end
end
