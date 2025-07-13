# language: pt
# features/authentication/definir_senha.feature

Funcionalidade: Definição de Senha para Novos Usuários
  Como um novo usuário que foi cadastrado no sistema,
  eu quero receber um link por e-mail para definir minha senha
  a fim de acessar o sistema pela primeira vez de forma segura.

  Contexto:
    Dado que um usuário foi criado com o e-mail "novo.participante@email.com" e ele recebeu um e-mail para definição de senha

  Cenário: Usuário define a senha com sucesso usando um token válido
    Quando eu abro o link de definição de senha recebido no e-mail
    E eu preencho o campo "Nova Senha" com "umaSenhaForte123"
    E eu preencho o campo "Confirmação da Senha" com "umaSenhaForte123"
    E eu clico no botão "Definir Senha"
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem "Senha definida com sucesso! Você já pode fazer login."
    E agora eu consigo fazer login com o e-mail "novo.participante@email.com" e senha "umaSenhaForte123"

  Cenário: Usuário tenta usar um link com token inválido
    Quando eu tento visitar a página de definição de senha com um token inválido
    Então eu devo ser redirecionado para a página de "Login"
    E eu devo ver a mensagem de erro "Link para definição de senha inválido ou expirado."

  Cenário: Usuário digita senhas que não correspondem
    Quando eu abro o link de definição de senha recebido no e-mail
    E eu preencho o campo "Nova Senha" com "senhaBoa1"
    E eu preencho o campo "Confirmação da Senha" com "senhaRuim2"
    E eu clico no botão "Definir Senha"
    Então eu devo permanecer na página de definição de senha
    E eu devo ver a mensagem de erro "A confirmação de senha não corresponde à senha."
