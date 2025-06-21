# language: pt

Funcionalidade: Cadastrar participantes via importação de dados do SIGAA
  Como um Administrador
  Eu quero cadastrar participantes de turmas do SIGAA ao importar dados de usuarios novos para o sistema
  A fim de que eles possam acessar o sistema CAMAAR

Contexto: Administrador na página de gerenciamento
  Dado que eu sou um usuário com o papel de "Administrador" e estou logado
  E eu estou na página de "Gerenciamento do CAMAAR"

# Happy Path
Cenário: Cadastro e notificação de novos participantes bem-sucedidos
  Dado que os dados do SIGAA contêm novos participantes que não existem no CAMAAR
  E o serviço de envio de emails está funcionando corretamente
  Quando eu clico no botão "Importar Dados do SIGAA"
  Então eu devo ver a mensagem "Todos os emails de cadastro foram enviados com sucesso."
  E os novos participantes devem ter sido criados na base de dados
  E um email de cadastro deve ter sido enviado para cada novo participante

# Sad Path
Cenário: Falha no envio de email de cadastro para um ou mais participantes
  Dado que os dados do SIGAA contêm um novo participante "usuario.com.falha@email.com"
  E o serviço de envio de emails falha ao tentar enviar para "usuario.com.falha@email.com"
  Quando eu clico no botão "Importar Dados do SIGAA"
  Então eu devo ver a mensagem de erro "Falha ao enviar email de cadastro para usuario.com.falha@email.com"
  E o usuário "usuario.com.falha@email.com" deve ser criado com o status "Falha no Envio do Convite"

# Edge Case (mencionado na história de usuário: "caso não existam")
Cenário: Importação ignora participantes que já existem no sistema
  Dado que o participante "usuario.existente@email.com" já possui uma conta no CAMAAR
  E os dados de importação do SIGAA incluem "usuario.existente@email.com"
  Quando eu clico no botão "Importar Dados do SIGAA"
  Então eu não devo ver mensagens de erro ou sucesso relacionadas a "usuario.existente@email.com"
  E nenhum novo email de cadastro deve ser enviado para "usuario.existente@email.com"