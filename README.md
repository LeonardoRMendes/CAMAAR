# Descrição Sprint 3:

## Refatoração com RubyCritic:
### **Responsável**: João Pedro
- 
- 


## Testes com RSpec:
### **Responsável**: Leonardo Mendes
- Os testes previamente implementados na sprint-2 do projeto foram refatorados para aumentar a cobertura, atingindo uma coverage total de quase 93%.
### Para visualizar os resultados
```bash
bundle exec rspec
xdg-open coverage/index.html
```


## Documentação com RDoc:
### **Responsável**: João Lucas
- 
- 


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
