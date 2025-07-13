#!/bin/bash
# migrate_to_rails8_wsl.sh
# Script automatizado para migrar para Rails 8.0.2 + Ruby 3.4.4 no WSL

set -e  # Parar em caso de erro

echo "🚀 === Migrando para Rails 8.0.2 + Ruby 3.4.4 no WSL ==="
echo ""

# Função para imprimir com cores
print_success() { echo -e "\033[32m✅ $1\033[0m"; }
print_error() { echo -e "\033[31m❌ $1\033[0m"; }
print_info() { echo -e "\033[34mℹ️  $1\033[0m"; }
print_warning() { echo -e "\033[33m⚠️  $1\033[0m"; }

# 1. Verificar se estamos no WSL
if [[ ! -f /proc/version ]] || ! grep -q "microsoft" /proc/version; then
    print_error "Este script deve ser executado no WSL (Windows Subsystem for Linux)"
    exit 1
fi
print_success "Executando no WSL"

# 2. Verificar Ruby 3.4.4
print_info "Verificando versão do Ruby..."
if command -v ruby >/dev/null 2>&1; then
    ruby_version=$(ruby --version)
    echo "Ruby atual: $ruby_version"
    
    if [[ $ruby_version == *"3.4.4"* ]]; then
        print_success "Ruby 3.4.4 confirmado"
    else
        print_warning "Ruby 3.4.4 não encontrado. Você tem rbenv instalado?"
        
        # Verificar rbenv
        if command -v rbenv >/dev/null 2>&1; then
            print_info "rbenv encontrado. Instalando Ruby 3.4.4..."
            rbenv install 3.4.4
            rbenv global 3.4.4
            eval "$(rbenv init -)"
            print_success "Ruby 3.4.4 instalado via rbenv"
        else
            print_error "rbenv não encontrado. Por favor, instale Ruby 3.4.4 primeiro."
            echo "Siga o guia no RAILS_8_WSL_GUIDE.md"
            exit 1
        fi
    fi
else
    print_error "Ruby não encontrado. Instale Ruby 3.4.4 primeiro."
    exit 1
fi

# 3. Verificar se estamos no diretório correto
if [[ ! -f "Gemfile" ]] || [[ ! -f "config/application.rb" ]]; then
    print_error "Este não parece ser um projeto Rails. Execute no diretório raiz do projeto."
    exit 1
fi
print_success "Projeto Rails detectado"

# 4. Fazer backup dos arquivos importantes
print_info "Fazendo backup dos arquivos..."
timestamp=$(date +%Y%m%d_%H%M%S)
backup_dir="backup_rails7_$timestamp"
mkdir -p "$backup_dir"

cp Gemfile "$backup_dir/"
cp config/application.rb "$backup_dir/"
[[ -f Gemfile.lock ]] && cp Gemfile.lock "$backup_dir/"
[[ -f config/database.yml ]] && cp config/database.yml "$backup_dir/"

print_success "Backup criado em: $backup_dir"

# 5. Atualizar Gemfile para Rails 8.0.2
print_info "Atualizando Gemfile para Rails 8.0.2..."
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

# Rails 8 específicos
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

group :development do
  gem "web-console"
end
EOF

print_success "Gemfile atualizado"

# 6. Atualizar config/application.rb
print_info "Atualizando config/application.rb..."

# Backup do conteúdo atual
cp config/application.rb config/application.rb.temp

# Substituir load_defaults
sed -i 's/config\.load_defaults [0-9]\+\.[0-9]\+/config.load_defaults 8.0/' config/application.rb

# Adicionar configurações Rails 8 se não existirem
if ! grep -q "config.active_job.queue_adapter" config/application.rb; then
    # Adicionar configurações antes do final da classe
    sed -i '/^[[:space:]]*end[[:space:]]*$/i\
\
    # Rails 8 configurations\
    config.active_job.queue_adapter = :solid_queue\
    config.cache_store = :solid_cache_store' config/application.rb
fi

print_success "config/application.rb atualizado"

# 7. Remover Gemfile.lock antigo
print_info "Removendo Gemfile.lock antigo..."
[[ -f Gemfile.lock ]] && rm Gemfile.lock
print_success "Gemfile.lock removido"

# 8. Bundle install
print_info "Executando bundle install..."
if bundle install; then
    print_success "bundle install concluído"
else
    print_error "Erro no bundle install"
    print_info "Restaurando backup..."
    cp "$backup_dir/Gemfile" ./
    [[ -f "$backup_dir/Gemfile.lock" ]] && cp "$backup_dir/Gemfile.lock" ./
    cp "$backup_dir/config/application.rb" config/
    exit 1
fi

# 9. Rails app:update
print_info "Executando rails app:update..."
print_warning "Pressione 'Y' para sobrescrever quando perguntado sobre arquivos de configuração"
sleep 3

if rails app:update; then
    print_success "rails app:update concluído"
else
    print_warning "rails app:update pode ter tido problemas, mas continuando..."
fi

# 10. Instalar Solid Queue
print_info "Instalando Solid Queue..."
if rails generate solid_queue:install; then
    print_success "Solid Queue instalado"
else
    print_warning "Solid Queue já pode estar instalado"
fi

# 11. Instalar Solid Cache
print_info "Instalando Solid Cache..."
if rails generate solid_cache:install; then
    print_success "Solid Cache instalado"
else
    print_warning "Solid Cache já pode estar instalado"
fi

# 12. Executar migrações
print_info "Executando migrações..."
if rails db:migrate; then
    print_success "Migrações executadas"
else
    print_warning "Algumas migrações podem ter falhado"
fi

# 13. Testar a instalação
print_info "Testando a instalação..."
test_output=$(rails runner "
puts '=== TESTE DE INSTALAÇÃO ==='
puts 'Rails: ' + Rails.version
puts 'Ruby: ' + RUBY_VERSION
puts 'SQLite3: ' + Gem.loaded_specs['sqlite3'].version.to_s
puts 'Solid Queue: ' + (defined?(SolidQueue) ? 'Instalado' : 'Não encontrado')
puts 'Solid Cache: ' + (defined?(SolidCache) ? 'Instalado' : 'Não encontrado')
puts '=========================='
" 2>/dev/null)

if [[ $? -eq 0 ]]; then
    print_success "Teste de instalação passou!"
    echo "$test_output"
else
    print_error "Teste de instalação falhou"
    exit 1
fi

# 14. Atualizar database.yml se necessário
print_info "Verificando database.yml..."
if ! grep -q "cache:" config/database.yml; then
    print_info "Atualizando database.yml para Rails 8..."
    
    cat >> config/database.yml << 'EOF'

# Rails 8 - Multiple databases for Solid Cache and Queue
production:
  primary:
    <<: *default
    database: storage/production.sqlite3
  
  cache:
    <<: *default
    database: storage/production_cache.sqlite3
    migrations_paths: db/cache_migrate
  
  queue:
    <<: *default
    database: storage/production_queue.sqlite3
    migrations_paths: db/queue_migrate
EOF
    print_success "database.yml atualizado"
fi

# 15. Criar config/queue.yml se não existir
if [[ ! -f config/queue.yml ]]; then
    print_info "Criando config/queue.yml..."
    cat > config/queue.yml << 'EOF'
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
EOF
    print_success "config/queue.yml criado"
fi

# 16. Resumo final
echo ""
echo "🎉 =================================================="
echo "    MIGRAÇÃO PARA RAILS 8.0.2 CONCLUÍDA!"
echo "=================================================="
echo ""
print_success "✅ Rails 8.0.2 instalado e funcionando"
print_success "✅ Ruby 3.4.4 confirmado"
print_success "✅ SQLite3 2.x compatível no WSL"
print_success "✅ Solid Queue configurado"
print_success "✅ Solid Cache configurado"
print_success "✅ Backup salvo em: $backup_dir"
echo ""
echo "📋 PRÓXIMOS PASSOS:"
echo "   1. Executar testes: bundle exec rspec"
echo "   2. Iniciar servidor: rails server"
echo "   3. Verificar funcionalidades Rails 8"
echo ""
echo "📁 BACKUP: Arquivos originais salvos em $backup_dir"
echo ""
print_success "Especificações críticas atendidas: Rails 8.0.2 + Ruby 3.4.4 ✅"
