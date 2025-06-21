# language: pt

Funcionalidade: Edicao e delecao de templates
  Eu como Administrador
  Quero editar e/ou deletar um template que eu criei sem afetar os formulários já criados
  A fim de organizar os templates existentes

Contexto: Administrador na página de gerenciamento de templates
  Dado que eu estou logado como um usuário "Administrador"
  E que eu esteja na página de gerenciamento de templates do CAMAAR

# Happy Path 1
Cenário: Exclusao bem-sucedida de um template
  Quando eu clicar no botão "excluir template" de um dado template de nome "template n" 
  Então o template deve ser excluido.
  E deve aparecer uma mensagem na tela dizendo: "Template n excluido com sucesso!"

# Sad Path 1
Cenário: Falha na exclusao de um template 
  Quando eu clicar no botão "excluir template" de um dado template de nome "template n" que não pode ser excluido.
  Então deve aparecer uma mensagem na tela dizendo: "Erro ao excluir Template n." e a justificativa do erro.

# Happy Path 2
Cenário: Edicao bem-sucedida de um template
  Quando eu clicar no botão "editar template" de um dado template de nome "template n".
  Então deve aparecer a aba de edição com os dados do template na tela para edição
  Quando clicar no botão "Salvar Edição" 
  Então deve aparecer a mensagem "Edição salva!".


# Sad Path 2
Cenário: Falha na edicao de um template 
  Quando eu clicar no botão "editar template" de um dado template de nome "template n".
  Então deve aparecer a aba de edição com os dados do template na tela para edição 
  E quando clicar no botão "Salvar Edição" mas der erro ao salvar 
  Então deve aparecer a mensagem "Erro ao salvar".