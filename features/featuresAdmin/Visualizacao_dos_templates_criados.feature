# language: pt

Funcionalidade: Visualizar templates
  Eu como Administrador
  Quero visualizar os templates criados
  A fim de poder editar e/ou deletar um template que eu criei

Contexto: Administrador na página de gerenciamento
  Dado que eu esteja em uma página do CAMAAR e autenticado como Administrador.
  
# Happy Path
Cenário: Existem templates criados
  Quando eu clicar no botão "Gerenciamento" no menu lateral.
  Então deve aparecer a tela de gerenciamento de templates com todos os templates que eu criei.

# Sad Path
Cenário: Não existem templates
  Quando eu clicar no botão "Gerenciamento" no menu lateral.
  Então deve aparecer na tela a mensagem "Não existem templates para exibição".