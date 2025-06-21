# language: pt

Funcionalidade: Criar formulário de avaliação a partir de um template
  Como um Administrador
  Eu quero criar um formulário baseado em um template para as turmas que eu escolher
  A fim de avaliar o desempenho das turmas no semestre atual

Contexto: Administrador na página de gerenciamento do CAMAAR
  Dado que eu sou um usuário com o papel de "Administrador" e estou logado
  E eu estou na página de "Gerenciamento do CAMAAR"

# Happy Path
Cenário: Administrador cria formulário e envia para uma turma com sucesso
  Quando eu clico no botão "Enviar formulários"
  Então a página de "Templates" deve abrir
  E eu devo ver todos os templates que ainda não foram enviados
  Quando eu clico no template desejado para selecioná-lo
  E eu aperto o botão "Enviar"
  Então a página de "Seleção de Turma" deve abrir
  E eu devo ver todas as turmas cadastradas no banco de dados
  Quando eu marcar o checkbox de seleção de uma turma
  E eu apertar o botão "Enviar"
  Então o sistema deve retornar para a página de "Templates"
  E o template usado para o formulário não deve mais aparecer na lista de templates disponíveis para envio

# Sad Path
Cenário: Administrador tenta criar formulário sem selecionar nenhuma turma
  Quando eu clico no botão "Enviar formulários"
  Então a página de "Templates" deve abrir
  E eu devo ver todos os templates que ainda não foram enviados
  Quando eu clico no template desejado para selecioná-lo
  E eu aperto o botão "Enviar"
  Então a página de "Seleção de Turma" deve abrir
  E eu devo ver todas as turmas cadastradas no banco de dados
  Quando eu apertar o botão "Enviar" sem selecionar nenhuma turma
  Então o sistema deve exibir a mensagem de erro "Uma turma deve ser selecionada"
