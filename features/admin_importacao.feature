# language: pt
Funcionalidade: Admin - Importação de Dados JSON
  Como um administrador
  Eu quero importar dados de turmas e discentes a partir de um arquivo JSON
  Para que eu possa carregar informações do sistema SIGAA

  Contexto:
    Dado que existe um usuário administrador com email "admin@test.com" e senha "senha123"
    E que eu estou logado como administrador

  Cenário: Upload bem-sucedido de arquivo JSON válido
    Dado que eu estou na página de importação de dados
    E que eu tenho um arquivo JSON válido com dados de turmas e discentes
    Quando eu anexo o arquivo "class_members_new.json" ao campo de upload "arquivo"
    E eu clico em "Importar Arquivo"
    Então eu devo ver uma mensagem de sucesso detalhando os dados importados
    E o usuário correspondente ao primeiro discente do arquivo JSON deve existir no banco de dados
    E a turma correspondente à primeira turma do arquivo JSON deve existir no banco de dados

  Cenário: Tentativa de upload sem selecionar arquivo
    Dado que eu estou na página de importação de dados
    Quando eu clico em "Importar Arquivo" sem selecionar um arquivo
    Então eu devo ver a mensagem "Por favor, selecione um arquivo para importar."

  Cenário: Upload de arquivo JSON inválido
    Dado que eu estou na página de importação de dados
    E que eu crio um arquivo de teste "invalid.json" com o conteúdo "{ invalid json"
    Quando eu anexo o arquivo "invalid.json" ao campo de upload "arquivo"
    E eu clico em "Importar Arquivo"
    Então eu devo ver a mensagem "JSON inválido"

  Cenário: Import de dados que já existem no sistema
    Dado que a primeira turma e o primeiro discente do arquivo "class_members_new.json" já existem no banco
    E que eu estou na página de importação de dados
    Quando eu anexo o arquivo "class_members_new.json" ao campo de upload "arquivo"
    E eu clico em "Importar Arquivo"
    Então a mensagem de sucesso deve indicar que "0 turmas, 0 discentes, 0 matrículas criadas"
