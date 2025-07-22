require_relative "boot"

require 'logger'

require "rails/all"

Bundler.require(*Rails.groups)

module TrabalhoFinal
  class Application < Rails::Application
    config.load_defaults 8.0

    config.autoload_lib(ignore: %w[assets tasks])

    # Rails 8 configurations
    config.active_job.queue_adapter = :solid_queue
    config.cache_store = :solid_cache_store
  end
end
