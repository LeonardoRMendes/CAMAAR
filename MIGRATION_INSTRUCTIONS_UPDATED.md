# Instruções de Migração Rails - Atualização Prática

## Situação Encontrada

Durante a tentativa de migração para Rails 8.0.2, encontramos algumas limitações:

1. **Rails 8.0.2**: Pode ainda não estar disponível ou estável
2. **Gems de compatibilidade**: Algumas gems ainda não têm versões compatíveis
3. **SQLite3 2.0**: Ainda não amplamente disponível

## Estratégia Recomendada: Migração Gradual

### Opção 1: Atualizar para Rails 7.2 (Mais Seguro)

Rails 7.2 oferece muitas melhorias e é mais estável:

```ruby
# Gemfile atualizado para Rails 7.2
source 'https://rubygems.org'
ruby '3.4.4'

gem 'rails', '~> 7.2.0'
gem 'sqlite3', '~> 1.7'
gem 'puma', '~> 6.5'
gem 'sass-rails', '>= 6'
gem 'turbo-rails', '~> 2.0'
gem 'stimulus-rails'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'sprockets-rails'
gem 'csv', '~> 3.2'
gem 'tzinfo-data', platforms: [:mingw, :mswin, :x64_mingw, :jruby]

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

### Comandos para Migração Rails 7.2

```powershell
# 1. Fazer backup
Copy-Item Gemfile Gemfile.backup
Copy-Item Gemfile.lock Gemfile.lock.backup
Copy-Item config\application.rb config\application.rb.backup

# 2. Atualizar o Gemfile (usar o conteúdo acima)

# 3. Atualizar config/application.rb
# Mudar config.load_defaults 7.1 para config.load_defaults 7.2

# 4. Instalar gems
bundle install

# 5. Executar atualizações
rails app:update

# 6. Executar migrações
rails db:migrate

# 7. Testar
bundle exec rails server
bundle exec rspec
bundle exec cucumber
```

### Opção 2: Aguardar Rails 8 Estável

Se você quiser usar Rails 8, recomendo:

1. **Aguardar versão estável**: Rails 8.0 ainda pode estar em beta
2. **Verificar compatibilidade**: Esperar todas as gems serem compatíveis
3. **Monitorar lançamento**: Acompanhar anúncios oficiais

## Benefícios do Rails 7.2

### Novas Funcionalidades do Rails 7.2
- **Better Performance**: Melhorias significativas de performance
- **Enhanced Security**: Recursos de segurança aprimorados
- **Improved Developer Experience**: Melhor experiência de desenvolvimento
- **Better Testing**: Ferramentas de teste aprimoradas
- **Database Improvements**: Melhorias no Active Record

### Diferenças 7.1 → 7.2

```ruby
# Melhorias de Performance
# Queries mais eficientes
# Melhor gestão de memória

# Novas funcionalidades de segurança
# Rate limiting básico
# Melhor sanitização

# Developer Experience
# Melhores mensagens de erro
# Debug tools aprimorados
```

## Configurações Recomendadas para Rails 7.2

### config/application.rb
```ruby
require_relative "boot"
require 'logger'
require "rails/all"

Bundler.require(*Rails.groups)

module TrabalhoFinal
  class Application < Rails::Application
    config.load_defaults 7.2
    config.autoload_lib(ignore: %w[assets tasks])
    
    # Melhorias de segurança
    config.force_ssl = Rails.env.production?
    
    # Performance
    config.active_record.query_log_tags_enabled = true
  end
end
```

### config/environments/production.rb (adicionar)
```ruby
Rails.application.configure do
  # ... configurações existentes ...
  
  # Performance optimizations
  config.active_record.query_log_tags_enabled = true
  config.active_record.automatic_scope_inversing = true
  
  # Security improvements
  config.force_ssl = true
  config.ssl_options = { 
    secure_cookies: true, 
    httponly_cookies: true 
  }
end
```

## Comandos de Verificação

```powershell
# Verificar versão
bundle exec rails --version

# Verificar gems
bundle list

# Verificar funcionamento
bundle exec rails console
# No console: User.first

# Testar servidor
bundle exec rails server

# Executar testes
bundle exec rspec
bundle exec cucumber
```

## Problemas Comuns e Soluções

### Problema: Bundle install falha
```powershell
# Limpar cache
bundle clean --force
rm Gemfile.lock
bundle install
```

### Problema: Migrações falham
```powershell
# Verificar status
rails db:migrate:status

# Reverter se necessário
rails db:rollback

# Migrar novamente
rails db:migrate
```

### Problema: Testes falham
```powershell
# Preparar banco de teste
rails db:test:prepare

# Executar testes específicos
bundle exec rspec spec/models/
```

## Próximos Passos

1. **Testar Rails 7.2**: Migrar para 7.2 e testar completamente
2. **Monitorar Rails 8**: Aguardar release estável
3. **Migração futura**: Planejar migração para Rails 8 quando estiver pronto

## Rollback (Se Necessário)

```powershell
# Restaurar arquivos originais
Copy-Item Gemfile.backup Gemfile
Copy-Item Gemfile.lock.backup Gemfile.lock
Copy-Item config\application.rb.backup config\application.rb

# Reinstalar gems originais
bundle install
```

---

**Recomendação Final**: Migre para Rails 7.2 agora, que oferece melhorias significativas e é estável. Aguarde Rails 8 para uma migração futura quando todas as dependências estiverem compatíveis.
