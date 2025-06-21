# language: pt

Funcionalidade: Atualizar a base de dados com os dados atuais do SIGAA
  Eu como Administrador
  Quero atualizar a base de dados já existente com os dados atuais do sigaa
  A fim de corrigir a base de dados do sistema.

Contexto: Administrador na página de importação
  Dado que eu esteja logado como administrador no CAMMAR e na página de gerenciamento.
  Quando eu clicar no botão "Importação" no menu lateral.
  Então deve abrir a janela de com as importações que foram feitas.
  Quando eu clicar no botão "Editar" de uma das importações 
  Então deve abrir uma janela para importar os novos dados.

# Happy Path
Cenário: Atualização bem sucedida
  Quando eu selecionar os novos dados 
  E clicar no botão "Salvar" 
  Então as atualizações serão salvos.
  E eu devo ver a mensagem de erro "Atualizado com sucesso."

# Sad Path
Cenário: Falha na atualização
  Quando eu selecionar os novos dados 
  E clicar no botão "Salvar" 
  Então deve aparecer a mensagem "Não foi possível salvar a nova importação".