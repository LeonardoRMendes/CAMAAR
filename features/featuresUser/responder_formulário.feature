# language: pt

Funcionalidade: Responder avaliação de turma
  Como um Participante de uma turma
  Eu quero responder o questionário sobre a turma em que estou matriculado
  A fim de submeter minha avaliação da turma

Contexto: Participante com avaliação pendente
  Dado que eu sou um usuário com o papel de "Participante" e estou logado
  E que existe a turma "Cálculo I" com a avaliação "Avaliação do Semestre" disponível
  E eu estou matriculado na turma "Cálculo I"
  E eu ainda não respondi a avaliação "Avaliação do Semestre"

# Happy Path
Cenário: Participante responde e envia uma avaliação com sucesso
  Quando eu visito a página de "Minhas Avaliações"
  Então eu devo ver o link para a avaliação "Avaliação do Semestre"
  Quando eu clico no link da avaliação "Avaliação do Semestre"
  Então eu sou direcionado para a página de resposta da avaliação
  Quando eu preencho todas as questões obrigatórias
  E eu clico no botão "Enviar Avaliação"
  Então eu devo ser redirecionado para a página de "Minhas Avaliações"
  E eu devo ver a mensagem "Avaliação enviada com sucesso!"
  E eu não devo mais ver o link para a avaliação "Avaliação do Semestre"

# Sad Path
Cenário: Participante tenta enviar uma avaliação com campos obrigatórios em branco
  Quando eu visito a página de "Minhas Avaliações"
  E eu clico no link da avaliação "Avaliação do Semestre"
  E eu clico no botão "Enviar Avaliação" sem preencher os campos obrigatórios
  Então eu devo permanecer na página de resposta da avaliação
  E eu devo ver a mensagem de erro "Todos os campos obrigatórios devem ser preenchidos"