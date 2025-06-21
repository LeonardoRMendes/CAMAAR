    # language: pt

Funcionalidade: Exportar resultados de avaliações
  Como um Administrador
  Eu quero baixar um arquivo CSV contendo os resultados de um formulário
  A fim de avaliar o desempenho das turmas

Contexto: Administrador na página de resultados com avaliações respondidas
  Dado que eu sou um usuário com o papel de "Administrador" e estou logado
  E que a avaliação "Desempenho Semestral - T01" foi respondida por pelo menos um participante
  E eu estou na página de "Resultados de Avaliações"
  Então eu devo ver a opção de baixar os resultados para "Desempenho Semestral - T01"

# Happy Path 1
Cenário: Administrador baixa com sucesso os resultados de uma avaliação
  Quando eu clico para baixar os resultados de "Desempenho Semestral - T01"
  E eu confirmo a ação de download
  Então eu devo ver a mensagem "O arquivo 'Desempenho Semestral - T01.csv' foi baixado com sucesso."
  E eu devo permanecer na página de "Resultados de Avaliações"

# Happy Path 2
Cenário: Administrador cancela a ação de baixar os resultados
  Quando eu clico para baixar os resultados de "Desempenho Semestral - T01"
  E eu cancelo a ação de download
  Então nenhuma mensagem de sucesso ou erro deve ser exibida
  E a opção para baixar os resultados de "Desempenho Semestral - T01" deve continuar visível

# Sad Path
Cenário: Sistema exibe um erro ao falhar na geração do arquivo CSV
  Dado que ocorre um erro no servidor ao tentar gerar o CSV para "Desempenho Semestral - T01"
  Quando eu clico para baixar os resultados de "Desempenho Semestral - T01"
  E eu confirmo a ação de download
  Então eu devo ver a mensagem de erro "Não foi possível gerar o arquivo de resultados para 'Desempenho Semestral - T01'."