# features/avaliacoes/responder_formulario.feature

Funcionalidade: Responder avaliação de turma
  Como um Participante de uma turma,
  eu quero responder o questionário sobre a turma em que estou matriculado
  a fim de submeter minha avaliação da turma.

  Contexto:
    Dado que eu sou um "Participante" logado
    E que a turma "Cálculo 1" possui o formulário "Avaliação Final"
    E o formulário "Avaliação Final" possui a questão obrigatória "O professor foi claro nas explicações?"
    E eu estou na página de resposta do formulário "Avaliação Final"

  Cenário: Participante responde e envia uma avaliação com sucesso 
    Quando eu preencho a resposta para "O professor foi claro nas explicações?" com "Sim, foi muito didático"
    E eu clico no botão "Enviar Avaliação"
    Então eu devo ser redirecionado para a página de "Minhas Avaliações" 
    E eu devo ver a mensagem "Avaliação enviada com sucesso!" 
    E a avaliação "Avaliação Final" não deve mais ser exibida como pendente 

  Cenário: Participante tenta enviar uma avaliação com campos obrigatórios em branco 
    Quando eu clico no botão "Enviar Avaliação" sem preencher os campos obrigatórios 
    Então eu devo permanecer na página de resposta da avaliação 
    E eu devo ver a mensagem de erro "Todos os campos obrigatórios devem ser preenchidos" 