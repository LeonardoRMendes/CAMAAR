# language: pt
# features/admin/visualizar_resultados.feature

Funcionalidade: Visualização de Resultados dos Formulários
  Como um Administrador,
  eu quero visualizar os resultados agregados de um formulário que foi respondido
  a fim de poder analisar o feedback das turmas.

  Cenário: Visualizar resultados de um formulário com uma resposta
    Dado que um formulário sobre "Didática" foi respondido por um participante com a resposta "Excelente" para a questão "Como você avalia a didática do professor?"
    E eu sou um "Administrador" logado
    Quando eu vou para a página de "Resultados"
    E eu clico para ver os resultados do formulário "Didática"
    Então eu devo ver o título da questão "Como você avalia a didática do professor?"
    E eu devo ver a resposta "Excelente" com a contagem de "1 voto"

  Cenário: Visualizar um formulário sem respostas
    Dado que o formulário "Metodologia de Ensino" foi criado mas não foi respondido por ninguém
    E eu sou um "Administrador" logado
    Quando eu vou para a página de "Resultados"
    E eu clico para ver os resultados do formulário "Metodologia de Ensino"
    Então eu devo ver a mensagem "Este formulário ainda não possui respostas."
