# language: pt

Funcionalidade: Criar template de formulário
  Como um Administrador
  Eu quero criar um template de formulário contendo as questões do formulário
  A fim de gerar formulários de avaliações para avaliar o desempenho das turmas

Contexto: Administrador na página de gerenciamento do CAMAAR
  Dado que eu sou um usuário com o papel de "Administrador" e estou logado
  E eu estou na página de "Gerenciamento do CAMAAR"

# Happy Path
Cenário: Administrador cria um template com sucesso
  Quando eu clico no botão "Editar templates"
  Então deve abrir a página de "Templates"
  E eu devo conseguir ver todos os templates que ainda não foram enviados como formulário
  Quando eu clico no botão "Criar template"
  Então a página de "Criar Template" deve abrir
  Quando eu preencho o nome do template com "<nome_template>"
  E eu adiciono uma questão
  E eu escolho o tipo da questão
  E eu adiciono as opções da questão
  Quando eu clico no botão "Criar"
  Então a página de "Criar Template" deve fechar
  E o novo template com o nome "<nome_template>" deve aparecer na lista de templates

# Sad Path 1
Cenário: Administrador tenta criar um template sem nome
  Quando eu clico no botão "Editar templates"
  Então deve abrir a página de "Templates"
  E eu devo conseguir ver todos os templates que ainda não foram enviados como formulário
  Quando eu clico no botão "Criar template"
  Então a página de "Criar Template" deve abrir
  Quando eu clico no botão "Criar"
  Então deve aparecer a mensagem de erro "O template deve ter um nome."

# Sad Path 2
Cenário: Administrador tenta criar um template sem adicionar questões
  Quando eu clico no botão "Editar templates"
  Então deve abrir a página de "Templates"
  E eu devo conseguir ver todos os templates que ainda não foram enviados como formulário
  Quando eu clico no botão "Criar template"
  Então a página de "Criar Template" deve abrir
  Quando eu preencho o nome do template com "<nome_template>"
  E eu clico no botão "Criar"
  Então deve aparecer a mensagem de erro "O template deve ter pelo menos uma questão."
