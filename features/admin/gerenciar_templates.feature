# features/admin/gerenciar_templates.feature

Funcionalidade: Gerenciamento de Templates de Formulário
  Como um Administrador,
  eu quero criar e gerenciar templates de formulário
  a fim de padronizar as questões que serão usadas nas avaliações das turmas.

  Contexto:
    Dado que eu sou um "Administrador" logado

  Cenário: Administrador cria um novo template com sucesso
    Quando eu vou para a página de "Gerenciamento de Templates"
    E eu clico no botão "Criar Novo Template"
    E eu preencho o campo "Nome do Template" com "Feedback Padrão Semestral"
    E eu adiciono a questão "Qual o seu nível de satisfação com a didática?"
    E eu clico no botão "Salvar Template"
    Então eu devo ver a mensagem "Template 'Feedback Padrão Semestral' criado com sucesso"
    E eu devo ver "Feedback Padrão Semestral" na lista de templates

  Cenário: Tentativa de criar um template sem nome
    Quando eu vou para a página de "Gerenciamento de Templates"
    E eu clico no botão "Criar Novo Template"
    E eu clico no botão "Salvar Template"
    Então eu devo ver a mensagem de erro "O template deve ter um nome"

  Cenário: Tentativa de criar um template sem questões
    Quando eu vou para a página de "Gerenciamento de Templates"
    E eu clico no botão "Criar Novo Template"
    E eu preencho o campo "Nome do Template" com "Template Vazio"
    E eu clico no botão "Salvar Template"
    Então eu devo ver a mensagem de erro "O template deve ter pelo menos uma questão"

  Cenário: Administrador edita o nome de um template com sucesso
    Dado que existe um template com o nome "Feedback Padrao Semestral"
    Quando eu vou para a página de "Gerenciamento de Templates"
    E eu clico em "Editar" para o template "Feedback Padrao Semestral"
    E eu preencho o campo "Nome do Template" com "Feedback Padrão 2025"
    E eu clico no botão "Salvar Template"
    Então eu devo ver a mensagem "Template 'Feedback Padrão 2025' atualizado com sucesso"
    E eu devo ver "Feedback Padrão 2025" na lista de templates
    E eu não devo mais ver "Feedback Padrao Semestral" na lista

  Cenário: Administrador exclui um template não utilizado com sucesso
    Dado que existe um template com o nome "Template Temporário"
    Quando eu vou para a página de "Gerenciamento de Templates"
    E eu clico em "Excluir" para o template "Template Temporário"
    Então eu devo ver a mensagem "Template 'Template Temporário' foi excluído com sucesso."
    E eu não devo mais ver "Template Temporário" na lista de templates

  Cenário: Administrador não consegue excluir um template que já foi usado
    Dado que o template "Relatório Anual" já foi usado para criar um formulário
    Quando eu vou para a página de "Gerenciamento de Templates"
    E eu clico em "Excluir" para o template "Relatório Anual"
    Então eu devo ver a mensagem de erro "Não é possível excluir o template 'Relatório Anual', pois ele já foi utilizado em formulários."
    E eu ainda devo ver "Relatório Anual" na lista de templates