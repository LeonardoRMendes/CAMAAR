# features/admin/importar_dados.feature

Funcionalidade: Importação de Dados via Arquivo JSON
  Como um Administrador,
  eu quero fazer o upload de um arquivo JSON contendo dados do SIGAA
  a fim de cadastrar novos usuários e configurar as turmas no sistema CAMAAR.

  Contexto:
    Dado que eu sou um "Administrador" logado
    E eu estou na página de "Importação de Dados"

  Cenário: Importação de um arquivo JSON bem-sucedida
    Quando eu anexo o arquivo "class_members.json" ao campo de upload "Arquivo JSON"
    E eu clico no botão "Importar Arquivo"
    Então eu devo ver uma mensagem de sucesso detalhando os dados importados
    E o usuário correspondente ao primeiro discente do arquivo JSON deve existir no banco de dados
    E a turma correspondente à primeira turma do arquivo JSON deve existir no banco de dados

  Cenário: Tentativa de importar um arquivo com formato inválido
    Dado que eu crio um arquivo de teste "invalido.json" com o conteúdo "{'formato': 'invalido'}"
    Quando eu anexo o arquivo "invalido.json" ao campo de upload "Arquivo JSON"
    E eu clico no botão "Importar Arquivo"
    Então eu devo ver a mensagem de erro "Ocorreu um erro ao processar o arquivo. Verifique o formato do JSON."

  Cenário: Importação não duplica usuários ou turmas existentes
    Dado que a primeira turma e o primeiro discente do arquivo "class_members.json" já existem no banco
    Quando eu anexo o arquivo "class_members.json" ao campo de upload "Arquivo JSON"
    E eu clico no botão "Importar Arquivo"
    Então a mensagem de sucesso deve indicar que "0 novos participantes e 0 novas turmas foram adicionados"