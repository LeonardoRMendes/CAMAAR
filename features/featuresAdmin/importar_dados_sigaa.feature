# language: pt

Funcionalidade: Importação de dados do SIGAA
  Como um Administrador
  Eu quero importar dados de turmas, matérias e participantes do SIGAA

Contexto: Administrador na página de gerenciamento
  Dado que eu estou logado como um usuário "Administrador"
  E eu estou na página de "Gerenciamento do CAMAAR"

# Happy Path
Cenário: Importação de dados bem-sucedida quando há novos dados
  Dado que o serviço do SIGAA possui novos dados para serem importados
  Quando eu clico no botão "Importar Dados do SIGAA"
  Então eu devo ver a mensagem "Dados importados com sucesso."
  E os novos dados de turmas, matérias e participantes devem constar na base de dados local

# Sad Path
Cenário: Falha na importação quando o serviço do SIGAA está indisponível
  Dado que o serviço do SIGAA está indisponível ou retorna um erro
  Quando eu clico no botão "Importar Dados do SIGAA"
  Então eu devo ver a mensagem de erro "Ocorreu um erro na comunicação com o SIGAA. Tente novamente mais tarde."
  E nenhum novo dado deve ser salvo na base de dados