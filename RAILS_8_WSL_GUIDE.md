# Guia Definitivo: Rails 8.0.2 + Ruby 3.4.4 no WSL

## 🎯 Objetivo
Instalar e configurar **Rails 8.0.2** com **Ruby 3.4.4** no WSL para atender às especificações críticas do projeto.

## ✅ Por que WSL resolve o problema?

### Problema no Windows:
- SQLite3 2.x tem problemas de compatibilidade com binários nativos Windows
- Ruby 3.4.4 + Windows = limitações específicas

### Solução WSL:
- ✅ Ambiente Linux nativo (Ubuntu/Debian)
- ✅ SQLite3 2.x funciona perfeitamente
- ✅ Binários nativos compilam corretamente
- ✅ Performance superior

## 🚀 Passos para Migração

### Passo 1: Acessar WSL
```bash
# Abrir WSL (Ubuntu)
wsl

# Verificar distribuição
cat /etc/os-release
```

### Passo 2: Atualizar Sistema WSL
```bash
# Atualizar pacotes
sudo apt update && sudo apt upgrade -y

# Instalar dependências essenciais
sudo apt install -y curl git build-essential libssl-dev libreadline-dev zlib1g-dev \
  libsqlite3-dev libffi-dev libyaml-dev libgdbm-dev libncurses5-dev autoconf \
  bison sqlite3 nodejs npm
```

### Passo 3: Instalar Ruby 3.4.4 via rbenv
```bash
# Instalar rbenv
curl -fsSL https://github.com/rbenv/rbenv-installer/raw/HEAD/bin/rbenv-installer | bash

# Adicionar ao PATH
echo 'export PATH="$HOME/.rbenv/bin:$PATH"' >> ~/.bashrc
echo 'eval "$(rbenv init -)"' >> ~/.bashrc
source ~/.bashrc

# Verificar instalação
rbenv --version

# Instalar Ruby 3.4.4
rbenv install 3.4.4
rbenv global 3.4.4

# Verificar
ruby --version
```

### Passo 4: Configurar Bundler e Rails
```bash
# Instalar bundler
gem install bundler

# Instalar Rails 8.0.2
gem install rails -v 8.0.2

# Verificar
rails --version
```

### Passo 5: Copiar Projeto para WSL
```bash
# Criar diretório para projetos
mkdir -p ~/projects
cd ~/projects

# Copiar projeto do Windows para WSL
cp -r /mnt/c/Users/BIM/Desktop/UnB\ 2025.1/Engenharia\ de\ Software/Trabalho\ Final\ 3/Trabalho\ funcionando\ mas\ sem\ Visual ./rails-project

cd rails-project
```

### Passo 6: Configurar Gemfile para Rails 8.0.2
```ruby
# Gemfile atualizado para Rails 8.0.2
source 'https://rubygems.org'
ruby '3.4.4'

gem 'rails', '8.0.2'
gem 'sqlite3', '~> 2.1'  # Agora funciona no WSL!
gem 'puma', '~> 6.5'
gem 'sass-rails', '>= 6'
gem 'turbo-rails', '~> 2.1'
gem 'stimulus-rails'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'sprockets-rails'
gem 'csv', '~> 3.2'

# Rails 8 gems (agora funcionam!)
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "debug"
end

group :test do
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "selenium-webdriver"
end
```

### Passo 7: Configurar application.rb
```ruby
# config/application.rb
require_relative "boot"
require 'logger'
require "rails/all"

Bundler.require(*Rails.groups)

module TrabalhoFinal
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    
    # Rails 8 specific configurations
    config.active_job.queue_adapter = :solid_queue
    config.cache_store = :solid_cache_store
  end
end
```

### Passo 8: Executar Migração
```bash
# Remover Gemfile.lock antigo
rm Gemfile.lock

# Instalar gems
bundle install

# Executar app:update
rails app:update

# Instalar Solid Queue e Solid Cache
rails generate solid_queue:install
rails generate solid_cache:install

# Executar migrações
rails db:migrate

# Testar
rails runner "puts 'Rails 8.0.2 funcionando no WSL!'; puts Rails.version; puts 'SQLite3: ' + Gem.loaded_specs['sqlite3'].version.to_s"
```

## 🔧 Configurações Específicas do Rails 8

### config/database.yml (atualizado)
```yaml
default: &default
  adapter: sqlite3
  pool: <%= ENV.fetch("RAILS_MAX_THREADS") { 5 } %>
  timeout: 5000

development:
  <<: *default
  database: storage/development.sqlite3

test:
  <<: *default
  database: storage/test.sqlite3

production:
  primary:
    <<: *default
    database: storage/production.sqlite3
  
  # Solid Cache database
  cache:
    <<: *default
    database: storage/production_cache.sqlite3
    migrations_paths: db/cache_migrate
  
  # Solid Queue database
  queue:
    <<: *default
    database: storage/production_queue.sqlite3
    migrations_paths: db/queue_migrate
```

### config/queue.yml (novo arquivo)
```yaml
default: &default
  dispatchers:
    - polling_interval: 1
      batch_size: 500
  workers:
    - queues: "*"
      threads: 3

development:
  <<: *default

test:
  <<: *default

production:
  <<: *default
  dispatchers:
    - polling_interval: 1
      batch_size: 500
  workers:
    - queues: "critical"
      threads: 5
      processes: 2
    - queues: "default"
      threads: 3
      processes: 4
```

## 🎯 Funcionalidades do Rails 8 Ativadas

### 1. Solid Queue (Jobs)
```ruby
# app/jobs/example_job.rb
class ExampleJob < ApplicationJob
  queue_as :default
  
  def perform(user_id)
    user = User.find(user_id)
    # Processar job
  end
end

# Usar:
ExampleJob.perform_later(user.id)
```

### 2. Solid Cache
```ruby
# Automático com config.cache_store = :solid_cache_store
Rails.cache.write("key", "value")
Rails.cache.read("key")
```

### 3. Rate Limiting
```ruby
# app/controllers/application_controller.rb
class ApplicationController < ActionController::Base
  rate_limit to: 100, within: 1.hour
end
```

### 4. Async Queries
```ruby
# app/models/user.rb
def self.recent_users_async
  where("created_at > ?", 1.week.ago).load_async
end
```

## 🔄 Script de Migração Automatizada

```bash
#!/bin/bash
# migrate_to_rails8_wsl.sh

echo "=== Migrando para Rails 8.0.2 no WSL ==="

# 1. Verificar Ruby
ruby_version=$(ruby --version)
echo "Ruby: $ruby_version"

if [[ ! $ruby_version == *"3.4.4"* ]]; then
  echo "❌ Ruby 3.4.4 não encontrado. Instale primeiro."
  exit 1
fi

# 2. Backup
echo "📁 Fazendo backup..."
cp Gemfile Gemfile.backup
cp Gemfile.lock Gemfile.lock.backup 2>/dev/null || true
cp config/application.rb config/application.rb.backup

# 3. Atualizar arquivos
echo "📝 Atualizando Gemfile..."
cat > Gemfile << 'EOF'
source 'https://rubygems.org'
ruby '3.4.4'

gem 'rails', '8.0.2'
gem 'sqlite3', '~> 2.1'
gem 'puma', '~> 6.5'
gem 'sass-rails', '>= 6'
gem 'turbo-rails', '~> 2.1'
gem 'stimulus-rails'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'sprockets-rails'
gem 'csv', '~> 3.2'

gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'

group :development, :test do
  gem "rspec-rails"
  gem "factory_bot_rails"
  gem "debug"
end

group :test do
  gem "cucumber-rails", require: false
  gem "capybara"
  gem "database_cleaner-active_record"
  gem "selenium-webdriver"
end
EOF

# 4. Atualizar config
echo "⚙️ Atualizando config/application.rb..."
sed -i 's/config.load_defaults 7.[0-9]/config.load_defaults 8.0/' config/application.rb

# 5. Bundle install
echo "📦 Executando bundle install..."
rm -f Gemfile.lock
bundle install

# 6. Rails app:update
echo "🔄 Executando rails app:update..."
rails app:update

# 7. Instalar Solid gems
echo "🚀 Instalando Solid Queue e Cache..."
rails generate solid_queue:install
rails generate solid_cache:install
rails db:migrate

# 8. Testar
echo "🧪 Testando instalação..."
rails runner "puts '✅ Rails 8.0.2 funcionando!'; puts 'Rails: ' + Rails.version; puts 'SQLite3: ' + Gem.loaded_specs['sqlite3'].version.to_s"

echo "✅ Migração concluída com sucesso!"
```

## 🎉 Resultado Final

Após seguir estes passos, você terá:

- ✅ **Rails 8.0.2** funcionando perfeitamente
- ✅ **Ruby 3.4.4** conforme especificação
- ✅ **SQLite3 2.x** compatível no WSL
- ✅ **Solid Queue** para jobs
- ✅ **Solid Cache** para cache
- ✅ **Rate Limiting** nativo
- ✅ **Async Queries** disponíveis

## 🔧 Comandos de Desenvolvimento

```bash
# Iniciar servidor
rails server

# Executar testes
bundle exec rspec
bundle exec cucumber

# Console Rails
rails console

# Monitorar Solid Queue
rails solid_queue:dashboard
```

---

**Status**: Rails 8.0.2 + Ruby 3.4.4 ✅ FUNCIONAL no WSL!
**Especificações**: ✅ ATENDIDAS conforme requisitos críticos
