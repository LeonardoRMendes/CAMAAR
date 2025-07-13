# Rails 8.0.2 Migration Script for Windows PowerShell
# Este script automatiza a migração do Rails 7.1 para Rails 8.0.2

Write-Host "=== Iniciando Migração Rails 7.1 → 8.0.2 ===" -ForegroundColor Green

# 1. Fazer backup dos arquivos importantes
Write-Host "📁 Fazendo backup dos arquivos importantes..." -ForegroundColor Yellow
Copy-Item Gemfile Gemfile.backup -ErrorAction SilentlyContinue
Copy-Item Gemfile.lock Gemfile.lock.backup -ErrorAction SilentlyContinue
Copy-Item config\application.rb config\application.rb.backup -ErrorAction SilentlyContinue
Copy-Item storage\development.sqlite3 storage\development.sqlite3.backup -ErrorAction SilentlyContinue
Copy-Item storage\test.sqlite3 storage\test.sqlite3.backup -ErrorAction SilentlyContinue

# 2. Verificar versão atual
Write-Host "📋 Versão atual do Rails:" -ForegroundColor Cyan
rails --version

# 3. Atualizar Gemfile
Write-Host "📝 Atualizando Gemfile..." -ForegroundColor Yellow
$gemfileContent = @"
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
"@

$gemfileContent | Out-File -FilePath Gemfile -Encoding UTF8

# 4. Bundle update
Write-Host "📦 Executando bundle update..." -ForegroundColor Yellow
bundle update

# 5. Atualizar config/application.rb
Write-Host "⚙️ Atualizando configuração..." -ForegroundColor Yellow
$configContent = Get-Content config\application.rb -Raw
$configContent = $configContent -replace 'config\.load_defaults 7\.1', 'config.load_defaults 8.0'
$configContent | Out-File -FilePath config\application.rb -Encoding UTF8

# 6. Executar rails app:update
Write-Host "🔄 Executando rails app:update..." -ForegroundColor Yellow
rails app:update

# 7. Executar migrações
Write-Host "🗄️ Executando migrações..." -ForegroundColor Yellow
rails db:migrate

# 8. Instalar Solid Queue e Solid Cache (opcional)
Write-Host "🚀 Instalando Solid Queue e Solid Cache..." -ForegroundColor Yellow
try {
    rails generate solid_queue:install
    rails generate solid_cache:install
    rails db:migrate
} catch {
    Write-Host "⚠️ Aviso: Não foi possível instalar Solid Queue/Cache. Isso é normal se as gems não estiverem disponíveis." -ForegroundColor Yellow
}

# 9. Executar testes
Write-Host "🧪 Executando testes..." -ForegroundColor Yellow
Write-Host "Executando RSpec..." -ForegroundColor Cyan
try {
    bundle exec rspec
} catch {
    Write-Host "❌ Alguns testes RSpec falharam" -ForegroundColor Red
}

Write-Host "Executando Cucumber..." -ForegroundColor Cyan
try {
    bundle exec cucumber
} catch {
    Write-Host "❌ Alguns testes Cucumber falharam" -ForegroundColor Red
}

# 10. Verificar nova versão
Write-Host "✅ Nova versão do Rails:" -ForegroundColor Green
rails --version

Write-Host ""
Write-Host "=== Migração Concluída ===" -ForegroundColor Green
Write-Host "📋 Resumo:" -ForegroundColor Cyan
Write-Host "  - Arquivos de backup criados (.backup)"
Write-Host "  - Gemfile atualizado para Rails 8.0.2"
Write-Host "  - Configurações atualizadas"
Write-Host "  - Solid Queue e Solid Cache instalados (se disponíveis)"
Write-Host "  - Migrações executadas"
Write-Host ""
Write-Host "🔍 Próximos passos:" -ForegroundColor Yellow
Write-Host "  1. Revisar os logs de teste acima"
Write-Host "  2. Testar a aplicação manualmente: rails server"
Write-Host "  3. Verificar se todas as funcionalidades estão funcionando"
Write-Host "  4. Se houver problemas, use os arquivos .backup para reverter"
Write-Host ""
Write-Host "🚨 Em caso de problemas:" -ForegroundColor Red
Write-Host "  - Restaurar Gemfile: Copy-Item Gemfile.backup Gemfile"
Write-Host "  - Restaurar config: Copy-Item config\application.rb.backup config\application.rb"
Write-Host "  - Executar: bundle install"
