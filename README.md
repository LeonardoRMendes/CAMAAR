(As informações da Sprint 2 estão descritas na <a href="https://github.com/LeonardoRMendes/CAMAAR/wiki">Wiki</a> do github)

```https://github.com/LeonardoRMendes/CAMAAR/wiki```
# Descrição Sprint 3:

## Refatoração com RubyCritic:
### **Responsável**: João Pedro
- Abaixo primeiramente temos a tabela mais geral que contém todos os controllers que foram alterados, e a mudança de complexity per method
  
| Controller           | Complexity per method Velho| Complexity per method Novo |
| :---: | :---: | :---: |
| templates_controller | 18.4               |               10.8             |
| formularios_controller  | 11.1               |                 8.7           |
| respostas_controller  | 35.0               |                 12.7            |
| sessions_controller  | 18.0               |                 10.5            |
| importacoes_controller  | 15.3              |                 7.1            |

-  Abaixo tem a comparação da mudança dos metodos ds controllers que foram apontados como tendo complexidade alta pelo RubyCritic, como o RubyCritic só mostra o flog do metodo se ele tiver complexidade alta, não temos certeza no flog dos metodos refatorados, temos certeza que pelo menos o flog é menor que 26, já que esse foi o maior flog que ainda dava alerta de complexidade alta

-  **templates_controller**: Nesse controller foram mudados os métodos "create" e "update"
    -  **create**: Esse metodo tava com um flog score de 58, e na sua refatoração funçoes que existiam dentro do create foram transformados nos metodos auxiliares "templateValido?" e "criarQuestao".
    -  **update**: Esse metodo tava com um flog score de 80, na refatoração 4 funções que estavam dentro de "update" se transformarem nos metodos auxiliares "updateQuestoesExis" , "updateQuestoesNovas" , "removerQuestoes" e "nomeValidoupdate".
-  **formularios_controller**: Nesse controller foi mudado o método "create"
    - **create**: Esse método tava com um flog score de 39, em sua refatoraçao foram criados os metodos auxiliares "formularioValido" , "criarFormularioTurmas" que auxiliam "create"
-  **respostas_controller**: Nesse controller foi mudado o método "create"
    -  **create**: Esse método estava com um flog score de 67, em sua refatoração foram criados os métodos auxiliares "questoesObrig", "questoesObrigfal" , "criaAvaliacao" e "conteudoQuestoes" que auxiliam "create"
-  **sessions_controller**: Nesse controller foi mudado o método "create"
    -  **create**: Esse método estava com um flog score de 51, na sua refatoração foram criados os métodos auxiliares "logSection" e "testarSenha" que auxiliam o método "create"
-  **importacoes_controller**: Nesse controller foi mudado o método "create"
    -  **create**: Esse método estava com um flog score de 41, na sua refatoração foram criados os métodos auxiliares "importSucess" , "importFailure" e "importResult" que auxiliam o método "create"


## Testes com RSpec:
### **Responsável**: Leonardo Mendes
- Os testes previamente implementados na sprint-2 do projeto foram refatorados para aumentar a cobertura, atingindo uma coverage total de quase 93%.
### Para visualizar os resultados
```bash
bundle exec rspec
xdg-open coverage/index.html
```


## Documentação com RDoc:
### **Responsável**: João Lucas Sales Aragão
Foram adicionados comentários de documentação RDoc aos métodos definidos manualmente nas controllers, models, services e mailers em /app. Para cada método, foi incluída uma breve descrição de sua funcionalidade, os parâmetros esperados (@param), o valor de retorno (@return) e possíveis efeitos colaterais (@note), conforme especificado pela na descrição da Sprint 3. Após a documentação, se gerou com sucesso a documentação HTML.


# CAMAAR - Sistema de Avaliação Acadêmica

Sistema web para avaliação de turmas acadêmicas desenvolvido em Ruby on Rails.

## Setup Rápido

### Linux/Mac
```bash
chmod +x setup.sh
./setup.sh
```

## Credenciais de Teste

- **Admin**: admin@unb.br / admin123
- **Usuário**: user@unb.br / user123

## Funcionalidades

- Sistema de autenticação (admin/participante)
- Criação de templates de avaliação
- Geração de formulários para turmas
- Tipos de questão: texto livre e múltipla escolha
- Exportação de resultados em CSV
- Dashboard administrativo

## Tecnologias

- Ruby 3.4.4
- Rails 8.0.2
- SQLite3
- Bootstrap CSS

## Usuários padrão

Após executar o setup:

**Administrador:**
- Email: `admin@unb.br`
- Senha: `admin123`

**Usuário Comum:**
- Email: `user@unb.br`
- Senha: `user123`
- Tem 1 avaliação pendente para testar

## Como rodar os testes

### Testes RSpec
```bash
bundle exec rspec
```

### Testes BDD com Cucumber
```bash
bundle exec cucumber
```

## Comandos úteis

### Resetar banco de dados
```bash
rails db:drop db:create db:migrate db:seed
```

### Executar console Rails
```bash
rails console
```

### Verificar rotas disponíveis
```bash
rails routes
```

## Estrutura do projeto

```
├── app/
│   ├── controllers/     # Controladores
│   ├── models/         # Modelos
│   ├── views/          # Views (templates)
│   └── services/       # Serviços
├── config/             # Configurações
├── db/                 # Banco de dados e migrações
├── features/           # Testes BDD (Cucumber)
├── spec/              # Testes RSpec
└── test/              # Testes unitários
```

## Funcionalidades principais

- **Autenticação**: Login/logout de usuários
- **Administração**: Gerenciamento de templates e formulários
  - **Templates**: Criar, editar, excluir templates de avaliação
  - **Questões**: Adicionar, editar, remover questões dos templates
  - **Formulários**: Criar e excluir formulários de avaliação
  - **CRUD Completo**: Interface completa para gerenciar questões e formulários
- **Avaliações**: Sistema de resposta a questionários
- **Importação**: Upload de dados via JSON (SIGAA)
- **Relatórios**: Visualização e exportação de resultados
- **Multi-perfil**: Administradores e Participantes
