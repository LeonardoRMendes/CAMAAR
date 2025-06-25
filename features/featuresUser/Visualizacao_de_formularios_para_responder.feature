# language: pt

Funcionalidade: Visualizar formularios para responder
  Eu como Participante de uma turma
  Quero visualizar os formulários não respondidos das turmas em que estou matriculado
  A fim de poder escolher qual irei responder

Contexto: Usuario na página de avaliações
  Dado em que eu esteja logado como usuário e na pagina de avaliações do CAMAAR
  E Devo ver as turmas em que estou matriculado.

# Happy Path
Cenário: Formularios a responder
  Quando eu clicar em uma das minhas turmas 
  Então deve abrir a lista de formulários que ainda não foram respondidos por mim.

# Sad Path
Cenário: Sem formularios a responder
  Quando eu clicar em uma das minhas turmas
  Então deve aparecer a mensagem: "Todos os formulário dessa turma foram preenchidos".