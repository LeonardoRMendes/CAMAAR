# language: pt
# features/admin/exportar_relatorios.feature

Funcionalidade: Exportar Relatórios de Resultados
  Como um Administrador,
  eu quero baixar um arquivo CSV contendo os resultados de um formulário
  a fim de analisar e arquivar o feedback das turmas offline.

  Contexto:
    Dado que um formulário sobre "Didática" foi respondido por um participante com a resposta "Excelente" para a questão "Como você avalia a didática do professor?"
    E eu sou um "Administrador" logado
    E eu estou na página de resultados do formulário "Didática"

  Cenário: Exportar resultados para CSV com sucesso
    Quando eu clico no link "Exportar para CSV"
    Então um arquivo chamado "didatica_resultados.csv" deve ser baixado
    E o conteúdo do arquivo CSV deve conter o cabeçalho "Questão,Resposta,Votos"
    E o conteúdo do arquivo CSV deve conter a linha "\"Como você avalia a didática do professor?\",\"Excelente\",1"

  Cenário: Falha na geração do arquivo CSV
    Dado que ocorre um erro no servidor ao tentar gerar o CSV para o formulário "Didática"
    Quando eu clico no link "Exportar para CSV"
    Então eu devo permanecer na página de resultados
    E eu devo ver a mensagem de erro "Não foi possível gerar o arquivo de resultados."
