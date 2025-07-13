#!/bin/bash
# Rails 8.0.2 Migration Script
# Este script automatiza a migração do Rails 7.1 para Rails 8.0.2

echo "=== Iniciando Migração Rails 7.1 → 8.0.2 ==="

# 1. Fazer backup dos arquivos importantes
echo "📁 Fazendo backup dos arquivos importantes..."
cp Gemfile Gemfile.backup
cp Gemfile.lock Gemfile.lock.backup
cp config/application.rb config/application.rb.backup
cp storage/development.sqlite3 storage/development.sqlite3.backup 2>/dev/null || echo "Arquivo development.sqlite3 não encontrado"
cp storage/test.sqlite3 storage/test.sqlite3.backup 2>/dev/null || echo "Arquivo test.sqlite3 não encontrado"

# 2. Verificar versão atual
echo "📋 Versão atual do Rails:"
rails --version

# 3. Atualizar Gemfile
echo "📝 Atualizando Gemfile..."
cat > Gemfile << 'EOF'
source 'https://rubygems.org'
ruby '3.4.4'

gem 'rails', '~> 8.0.2'
gem 'sqlite3', '~> 2.0'
gem 'puma', '~> 6.5'
gem 'sass-rails', '>= 6'
gem 'turbo-rails', '~> 2.1'
gem 'stimulus-rails'
gem 'jbuilder', '~> 2.7'
gem 'bootsnap', '>= 1.4.4', require: false
gem 'bcrypt', '~> 3.1.7'
gem 'sprockets-rails'
gem 'csv', '~> 3.2'

# Novas gems do Rails 8 (opcionais mas recomendadas)
gem 'solid_cache'
gem 'solid_queue'
gem 'solid_cable'

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
EOF

# 4. Bundle update
echo "📦 Executando bundle update..."
bundle update

# 5. Atualizar config/application.rb
echo "⚙️ Atualizando configuração..."
sed -i.bak 's/config.load_defaults 7.1/config.load_defaults 8.0/' config/application.rb

# 6. Executar rails app:update
echo "🔄 Executando rails app:update..."
rails app:update

# 7. Executar migrações
echo "🗄️ Executando migrações..."
rails db:migrate

# 8. Instalar Solid Queue e Solid Cache (opcional)
echo "🚀 Instalando Solid Queue e Solid Cache..."
rails generate solid_queue:install
rails generate solid_cache:install
rails db:migrate

# 9. Executar testes
echo "🧪 Executando testes..."
echo "Executando RSpec..."
bundle exec rspec || echo "❌ Alguns testes RSpec falharam"

echo "Executando Cucumber..."
bundle exec cucumber || echo "❌ Alguns testes Cucumber falharam"

# 10. Verificar nova versão
echo "✅ Nova versão do Rails:"
rails --version

echo ""
echo "=== Migração Concluída ==="
echo "📋 Resumo:"
echo "  - Arquivos de backup criados (.backup)"
echo "  - Gemfile atualizado para Rails 8.0.2"
echo "  - Configurações atualizadas"
echo "  - Solid Queue e Solid Cache instalados"
echo "  - Migrações executadas"
echo ""
echo "🔍 Próximos passos:"
echo "  1. Revisar os logs de teste acima"
echo "  2. Testar a aplicação manualmente"
echo "  3. Verificar se todas as funcionalidades estão funcionando"
echo "  4. Se houver problemas, use os arquivos .backup para reverter"
echo ""
echo "🚨 Em caso de problemas:"
echo "  - Restaurar Gemfile: cp Gemfile.backup Gemfile"
echo "  - Restaurar config: cp config/application.rb.backup config/application.rb"
echo "  - Executar: bundle install"
