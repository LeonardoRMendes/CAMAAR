# Configurações Recomendadas para Rails 8.0.2

## 1. Solid Queue Configuration

### config/queue.yml
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
    - queues: "low"
      threads: 2
      processes: 2
```

### config/environments/production.rb
```ruby
Rails.application.configure do
  # ... outras configurações ...
  
  # Solid Queue configuration
  config.active_job.queue_adapter = :solid_queue
  
  # Solid Cache configuration
  config.cache_store = :solid_cache_store
  
  # Rate limiting
  config.force_ssl = true
  
  # Performance optimizations
  config.log_level = :info
  config.active_record.query_log_tags_enabled = true
end
```

### config/environments/development.rb
```ruby
Rails.application.configure do
  # ... outras configurações ...
  
  # Use Solid Queue in development too
  config.active_job.queue_adapter = :solid_queue
  
  # Use Solid Cache for better development experience
  config.cache_store = :solid_cache_store
end
```

## 2. Database Configuration Updates

### config/database.yml
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

## 3. Rate Limiting Configuration

### app/controllers/application_controller.rb
```ruby
class ApplicationController < ActionController::Base
  # Rate limiting for API endpoints
  rate_limit to: 100, within: 1.hour, only: [:create, :update, :destroy]
  rate_limit to: 1000, within: 1.hour, only: [:index, :show]
  
  private
  
  def current_user
    @current_user ||= User.find(session[:user_id]) if session[:user_id]
  end
  
  helper_method :current_user
end
```

### app/controllers/sessions_controller.rb
```ruby
class SessionsController < ApplicationController
  # Strict rate limiting for login attempts
  rate_limit to: 10, within: 1.hour, only: [:create], with: -> { request.ip }
  
  # ... resto do código ...
end
```

## 4. Async Queries Example

### app/models/user.rb (atualizado)
```ruby
class User < ApplicationRecord
  has_secure_password
  
  has_many :matriculas, dependent: :destroy
  has_many :turmas, through: :matriculas
  has_many :respostas, dependent: :destroy
  has_many :avaliacoes, class_name: 'Avaliacao', dependent: :destroy
  has_many :formularios, through: :avaliacoes
  
  enum role: { participante: 0, admin: 1 }
  
  validates :email, presence: true, uniqueness: true
  validates :password, length: { minimum: 6 }, allow_nil: true
  validates :password, confirmation: true, allow_nil: true
  
  def password_set?
    password_digest.present?
  end
  
  # Exemplo de query assíncrona
  def self.with_recent_activity_async
    where("updated_at > ?", 1.week.ago).load_async
  end
end
```

## 5. Job Examples with Solid Queue

### app/jobs/csv_export_job.rb
```ruby
class CsvExportJob < ApplicationJob
  queue_as :default
  
  def perform(user_id, formulario_id)
    user = User.find(user_id)
    formulario = Formulario.find(formulario_id)
    
    csv_data = CsvExportService.new(formulario).generate
    
    # Salvar arquivo ou enviar por email
    UserMailer.csv_export_ready(user, csv_data).deliver_now
  end
end
```

### app/jobs/import_job.rb
```ruby
class ImportJob < ApplicationJob
  queue_as :critical
  
  def perform(file_path, user_id)
    user = User.find(user_id)
    
    ImportService.new(file_path, user).process
    
    # Notificar conclusão
    UserMailer.import_completed(user).deliver_now
  rescue StandardError => e
    UserMailer.import_failed(user, e.message).deliver_now
    raise
  end
```

## 6. Cache Configuration

### app/controllers/dashboard_controller.rb (atualizado)
```ruby
class DashboardController < ApplicationController
  def index
    @stats = Rails.cache.fetch("dashboard_stats_#{current_user.id}", expires_in: 5.minutes) do
      {
        total_avaliacoes: current_user.avaliacoes.count,
        pending_forms: current_user.formularios.where(status: 'pending').count,
        recent_activity: current_user.respostas.recent.limit(5)
      }
    end
  end
end
```

## 7. Health Check Configuration

### config/routes.rb (atualizado)
```ruby
Rails.application.routes.draw do
  # ... rotas existentes ...
  
  # Health checks mais detalhados
  get "up" => "rails/health#show", as: :rails_health_check
  get "health/database" => "health#database"
  get "health/cache" => "health#cache"
  get "health/queue" => "health#queue"
  
  # ... resto das rotas ...
end
```

### app/controllers/health_controller.rb
```ruby
class HealthController < ApplicationController
  def database
    User.connection.execute("SELECT 1")
    render json: { status: "ok", database: "connected" }
  rescue StandardError => e
    render json: { status: "error", database: e.message }, status: 500
  end
  
  def cache
    Rails.cache.write("health_check", "ok")
    result = Rails.cache.read("health_check")
    render json: { status: "ok", cache: "working" }
  rescue StandardError => e
    render json: { status: "error", cache: e.message }, status: 500
  end
  
  def queue
    # Verificar se o Solid Queue está funcionando
    status = SolidQueue::Worker.all.any? ? "working" : "no workers"
    render json: { status: "ok", queue: status }
  rescue StandardError => e
    render json: { status: "error", queue: e.message }, status: 500
  end
end
```

## 8. Security Improvements

### config/application.rb (atualizado)
```ruby
require_relative "boot"
require 'logger'
require "rails/all"

Bundler.require(*Rails.groups)

module TrabalhoFinal
  class Application < Rails::Application
    config.load_defaults 8.0
    config.autoload_lib(ignore: %w[assets tasks])
    
    # Security configurations
    config.force_ssl = Rails.env.production?
    config.ssl_options = { 
      secure_cookies: true,
      httponly_cookies: true 
    } if Rails.env.production?
    
    # Rate limiting
    config.assume_ssl = Rails.env.production?
    
    # Better error handling
    config.exceptions_app = self.routes
  end
end
```

## 9. Performance Optimizations

### config/environments/production.rb (completo)
```ruby
require "active_support/core_ext/integer/time"

Rails.application.configure do
  config.enable_reloading = false
  config.eager_load = true
  config.consider_all_requests_local = false
  config.public_file_server.enabled = true
  
  # Asset pipeline
  config.assets.compile = false
  config.assets.digest = true
  
  # Logging
  config.log_level = ENV.fetch("RAILS_LOG_LEVEL", "info").to_sym
  config.log_tags = [ :request_id ]
  
  # Cache and Queue
  config.cache_store = :solid_cache_store
  config.active_job.queue_adapter = :solid_queue
  
  # Security
  config.force_ssl = true
  config.ssl_options = { 
    secure_cookies: true, 
    httponly_cookies: true 
  }
  
  # Performance
  config.active_record.query_log_tags_enabled = true
  config.active_record.automatic_scope_inversing = true
  
  # Rate limiting
  config.assume_ssl = true
end
```

## 10. Monitoring and Debugging

### config/initializers/solid_queue.rb
```ruby
SolidQueue.configure do |config|
  config.on_thread_error = ->(exception) do
    Rails.logger.error "SolidQueue thread error: #{exception.message}"
    Rails.logger.error exception.backtrace.join("\n")
  end
end
```

### lib/tasks/monitoring.rake
```ruby
namespace :monitoring do
  desc "Check system health"
  task health: :environment do
    puts "=== System Health Check ==="
    
    # Check database
    begin
      User.connection.execute("SELECT 1")
      puts "✅ Database: OK"
    rescue => e
      puts "❌ Database: #{e.message}"
    end
    
    # Check cache
    begin
      Rails.cache.write("test", "ok")
      Rails.cache.read("test")
      puts "✅ Cache: OK"
    rescue => e
      puts "❌ Cache: #{e.message}"
    end
    
    # Check queue
    begin
      workers = SolidQueue::Worker.count
      puts "✅ Queue: #{workers} workers running"
    rescue => e
      puts "❌ Queue: #{e.message}"
    end
  end
end
```
