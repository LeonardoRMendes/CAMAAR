# features/avaliacoes/visualizar_avaliacoes.feature

Funcionalidade: Visualizar Formulários para Responder
  Como um Participante de uma turma,
  eu quero visualizar os formulários não respondidos das turmas em que estou matriculado,
  a fim de poder escolher qual irei responder.

  Contexto:
    Dado que existe um usuário com o e-mail "participante@unb.br" e senha "senha123"
    E que existe a turma "Cálculo 1"
    E que eu estou matriculado na turma "Cálculo 1"
    Quando eu faço login com e-mail "participante@unb.br" e senha "senha123"
    E eu vou para a página "Minhas Avaliações"

  Cenário: Participante visualiza avaliações pendentes
    Dado que a turma "Cálculo 1" possui o formulário "Avaliação de Meio de Semestre" para ser respondido
    Então eu devo ver o card da turma "Cálculo 1"
    E dentro do card da turma, eu devo ver o link para a avaliação "Avaliação de Meio de Semestre"

  Cenário: Participante não possui avaliações pendentes em uma turma
    Dado que a turma "Cálculo 1" não possui formulários pendentes para mim
    Então eu devo ver o card da turma "Cálculo 1"
    E dentro do card da turma, eu devo ver a mensagem "Todos os formulários dessa turma foram respondidos."