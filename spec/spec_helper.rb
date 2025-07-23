require 'simplecov'
SimpleCov.start 'rails' do
  # Aqui você pode adicionar configurações, como agrupar arquivos. Exemplo:
  add_group "Controllers", "app/controllers"
  add_group "Models", "app/models"
  add_group "Mailers", "app/mailers"
  add_group "Services", "app/services"

  add_filter 'app/controllers/application_controller.rb'
  add_filter 'app/jobs/application_job.rb'
  add_filter 'app/mailers/application_mailer.rb'
  
  minimum_coverage 87.5
end

# O resto do seu arquivo spec_helper.rb vem DEPOIS daqui...
RSpec.configure do |config|
  # ...
end

RSpec
.configure do |config|
  config.expect_with :rspec do |expectations|
    expectations.include_chain_clauses_in_custom_matcher_descriptions = true
  end

  config.mock_with :rspec do |mocks|
    mocks.verify_partial_doubles = true
  end

  config.shared_context_metadata_behavior = :apply_to_host_groups
end
