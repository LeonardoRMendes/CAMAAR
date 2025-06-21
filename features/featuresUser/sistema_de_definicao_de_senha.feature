# language: pt

Funcionalidade: Definir senha a partir de link enviado por e-mail
  Como um Usuário
  Eu quero definir uma senha para o meu usuário a partir do e-mail do sistema de solicitação de cadastro
  A fim de acessar o sistema

Contexto: Usuário recebeu o e-mail de definição de senha
  Dado que eu tenha recebido o e-mail para definição de senha

# Happy Path
Cenário: Usuário define a senha com sucesso
  Quando eu clico no link para definição de senha
  Então deve abrir a página de definição de senha
  Quando eu preencho o campo "Senha" com uma <senha> de no mínimo 8 caracteres
  E eu preencho o campo "Confirmação de Senha" com a mesma <senha>
  E eu aperto o botão "Definir Senha"
  Então eu devo ser redirecionado para a página inicial de Login
  E eu devo ver a mensagem "Senha definida com sucesso"

# Sad Path 1
Cenário: Usuário preenche senhas diferentes
  Quando eu clico no link para definição de senha
  Então deve abrir a página de definição de senha
  Quando eu preencho o campo "Senha" com uma senha de no mínimo 8 caracteres
  E eu deixo o campo "Confirmação de Senha" vazio ou com valor diferente
  E eu aperto o botão "Definir Senha"
  Então eu devo ver a mensagem de erro "Senha e a confirmação de senha devem ser iguais"

# Sad Path 2
Cenário: Usuário tenta definir senha sem preencher os campos
  Quando eu clico no link para definição de senha
  Então deve abrir a página de definição de senha
  Quando eu aperto o botão "Definir Senha" sem preencher os campos
  Então eu devo ver a mensagem de erro "Senha deve ter no mínimo 8 caracteres"
