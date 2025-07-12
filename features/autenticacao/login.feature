# features/autenticacao/login.feature

Funcionalidade: Autenticação de Usuário
  Para proteger o acesso ao sistema, como um usuário cadastrado,
  eu quero poder fazer login com minhas credenciais.

  Contexto:
    Dado que existe um usuário com o e-mail "aluno@email.com" e senha "senha123"

  Cenário: Login bem-sucedido com credenciais válidas
    Quando eu vou para a página de login
    E eu preencho o campo "E-mail" com "aluno@email.com"
    E eu preencho o campo "Senha" com "senha123"
    E eu clico no botão "Entrar"
    Então eu devo ver a mensagem "Login realizado com sucesso!"
    E eu devo estar na página principal do participante

  Cenário: Falha no login com senha incorreta
    Quando eu vou para a página de login
    E eu preencho o campo "E-mail" com "aluno@email.com"
    E eu preencho o campo "Senha" com "senha_errada"
    E eu clico no botão "Entrar"
    Então eu devo ver a mensagem de erro "E-mail ou senha inválidos."
    E eu devo permanecer na página de login