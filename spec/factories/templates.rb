FactoryBot.define do
  factory :template do
    nome { "Template de Exemplo" }
    descricao { "Template para testes" }
    
    after(:create) do |template|
      create(:questao, template: template, texto: "Questão de exemplo")
    end
  end
end
