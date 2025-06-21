# language: pt

Funcionalidade: Visualizacao de resultados dos formularios
  Eu como Administrador
  Quero visualizar os formulários criados
  A fim de poder gerar um relatório a partir das respostas

Contexto: Administrador na página de resultados
  Dado em que eu esteja na página de gerenciamento do CAMAAR
  Quando eu clicar no botão "Resultados"
  Então deve abrir a página de resultados
  E devo conseguir ver todos os formulários que foram respondidos por pelo menos 1 usuário.

# Happy Path
Cenário: Acesso bem sucedido ao relatório
  Quando eu clicar no botão "Ver resultados" de um dado formulário.
  Então deve abrir uma pagina com o resumo das respostas do formulário com o número de respostas que cada alternativa por pergunta teve.

# Sad Path
Cenário: Falha ao acessar o relatório
  Quando eu clicar no botão "Ver resultados" de um dado formulário.
  Então deve aparecer uma mensagem alertando: "Não é possível visualizar resultados desse formulário."