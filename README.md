# CAMAAR - Sistema de Avaliação Acadêmica

Sistema web para avaliação de turmas acadêmicas desenvolvido em Ruby on Rails.

## Setup Rápido

### Windows
```cmd
setup.bat
```

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

## 🧪 Como rodar os testes

### Testes RSpec
```bash
bundle exec rspec
```

### Testes BDD com Cucumber
```bash
bundle exec cucumber
```

### Executar testes específicos
```bash
# Executar apenas testes de uma feature específica
bundle exec cucumber features/autenticacao/login.feature

# Executar testes com tags específicas
bundle exec cucumber --tags @admin
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

## Docker (Alternativo)

Se preferir usar Docker:

```bash
# Construir a imagem
docker build -t camaar .

# Executar o container
docker run -p 3000:3000 camaar
```

## Troubleshooting

### Erro de login "Email ou senha incorretos"
Se não conseguir fazer login:
```bash
# Verifique se está usando as credenciais corretas:
# Admin: admin@unb.br / admin123
# User: user@unb.br / user123

# Se necessário, recriar os usuários:
rails db:seed
```

### Erro "Opcoes can't be blank" no seeds.rb
Se aparecer erro de validação ao executar `rails db:seed`:
```bash
# O problema foi corrigido no seeds.rb
# Questões de múltipla escolha agora têm opções definidas automaticamente
# Execute novamente:
rails db:seed
```

### Erro "Permission denied" ao resetar banco
Se aparecer erro de permissão ao executar `rails db:reset`:
```bash
# 1. Pare o servidor Rails primeiro (Ctrl+C no terminal onde está rodando)
# 2. Em seguida execute:
rails db:reset

# Ou alternativamente, apenas recriar os dados:
rails db:seed
```

### Erro de dependências
```bash
bundle update
```

### Problemas com banco de dados
```bash
rails db:reset
```

### Erro de migrações duplicadas
Se aparecer erro como "Multiple migrations have the name...", verifique:
```bash
# Listar migrações duplicadas
ls db/migrate/ | sort | uniq -d

# Remover migração duplicada (exemplo)
rm db/migrate/TIMESTAMP_duplicate_migration.rb

# Resetar banco
rails db:drop db:create db:migrate db:seed
```

### Erro de importação JSON (NOT NULL constraint failed)
Se aparecer erro como "NOT NULL constraint failed: turmas.codigo":
```bash
# O problema já foi corrigido no código
# Tente a importação novamente
# Se persistir, verifique se o JSON tem os campos obrigatórios:
# - codigo_componente
# - nome_componente
# - id_turma
```

### Erro de validação de usuários na importação
Se aparecer erro relacionado a senha/password durante importação:
```bash
# O problema já foi corrigido no código
# Usuários importados recebem senha temporária automaticamente
# Eles receberão email para definir nova senha
```

### Erro de exportação CSV (cannot load such file -- csv)
Se aparecer erro "LoadError (cannot load such file -- csv)":
```bash
# O problema já foi corrigido no código
# A gem CSV foi adicionada ao Gemfile
# Execute os comandos na ordem:
bundle install
# IMPORTANTE: Pare o servidor Rails (Ctrl+C) e reinicie:
rails server
```

### Erro ao editar templates (no implicit conversion of Symbol into Integer)
Se aparecer erro "TypeError" ao salvar templates:
```bash
# O problema já foi corrigido no código
# Reinicie o servidor Rails para aplicar as correções:
# Ctrl+C para parar
rails server
```

### Erro SQL ao excluir formulários (no such table)
Se aparecer erro "SQLite3::SQLException: no such table":
```bash
# O problema já foi corrigido no código
# Foram feitas correções nos modelos Resposta e Avaliacao
# E o método de exclusão foi melhorado com tratamento de erros
# Reinicie o servidor Rails para aplicar as correções:
# Ctrl+C para parar
rails server
```

### Erro TZInfo::DataSourceNotFound (Windows)
Se aparecer erro "tzinfo-data is not present" no Windows:
```bash
# A gem tzinfo-data foi adicionada ao Gemfile
# Execute:
bundle install
rails db:seed
```

### Servidor não inicia
```bash
# Verificar se todas as gems estão instaladas
bundle install

# Verificar status das migrações
rails db:migrate:status

# Se necessário, resetar completamente
rails db:reset
```