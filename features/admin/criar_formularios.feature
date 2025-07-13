# features/admin/criar_formularios.feature

Funcionalidade: Criar Formulário de Avaliação a partir de um Template
  Como um Administrador,
  eu quero criar um formulário baseado em um template existente e associá-lo a turmas específicas
  a fim de iniciar o processo de avaliação do desempenho dessas turmas.

  Contexto:
    Dado que eu sou um "Administrador" logado
    E existe o template "Feedback Padrão Semestral"
    E existem as turmas "Cálculo 1" e "Física 1" cadastradas no sistema
    Quando eu vou para a página de "Gerenciamento de Formulários"
    E eu clico em "Criar Novo Formulário"

  Cenário: Administrador cria e envia um formulário para uma turma com sucesso
    Quando eu seleciono o template "Feedback Padrão Semestral"
    E eu seleciono a turma "Cálculo 1"
    E eu clico no botão "Gerar Formulário"
    Então eu devo ver a mensagem "Formulário 'Feedback Padrão Semestral' foi gerado e enviado para 1 turma(s)."
    E o participante "aluno@camaar.com" matriculado na turma "Cálculo 1" deve ter uma avaliação pendente

  Cenário: Tentativa de gerar um formulário sem selecionar um template
    Quando eu seleciono a turma "Cálculo 1"
    E eu clico no botão "Gerar Formulário"
    Então eu devo permanecer na página de criação de formulário
    E eu devo ver a mensagem de erro "É necessário selecionar um template."

  Cenário: Tentativa de gerar um formulário sem selecionar uma turma
    Quando eu seleciono o template "Feedback Padrão Semestral"
    E eu clico no botão "Gerar Formulário"
    Então eu devo permanecer na página de criação de formulário
    E eu devo ver a mensagem de erro "É necessário selecionar pelo menos uma turma."