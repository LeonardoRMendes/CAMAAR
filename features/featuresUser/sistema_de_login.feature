# language: pt

Funcionalidade: Login no sistema CAMAAR
  Como um Usuário do sistema
  Eu quero acessar o sistema utilizando um e-mail ou matrícula e uma senha já cadastrada
  A fim de responder formulários ou gerenciar o sistema

Contexto: Usuário na página inicial do CAMAAR
  Dado que eu estou na página inicial do CAMAAR

# Happy Path
Cenário: Usuário faz login com sucesso
  Quando eu preencho o campo "Nome de Usuário" com um valor válido
  E eu preencho o campo "Senha" com a senha correta
  E eu clico no botão "Login"
  Então eu devo ser redirecionado para a página de "Avaliações"

# Sad Path 1
Cenário: Usuário tenta fazer login sem informar o nome de usuário
  Quando eu clico no botão "Login"
  Então deve aparecer a mensagem de erro "É necessário informar um nome de usuário válido"

# Sad Path 2
Cenário: Usuário tenta fazer login sem informar a senha
  Quando eu preencho o campo "Nome de Usuário" com um valor válido
  E eu clico no botão "Login"
  Então deve aparecer a mensagem de erro "Senha incorreta"

# Sad Path 3
Cenário: Usuário tenta fazer login com senha incorreta
  Quando eu preencho o campo "Nome de Usuário" com um valor válido
  E eu preencho o campo "Senha" com uma senha incorreta
  E eu clico no botão "Login"
  Então deve aparecer a mensagem de erro "Senha incorreta"
