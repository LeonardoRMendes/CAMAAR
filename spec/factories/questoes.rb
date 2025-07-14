FactoryBot.define do
  factory :questao do
    texto { "Qual é sua opinião sobre a disciplina?" }
    tipo { :texto }
    obrigatoria { false }
    association :template
    opcoes { ["Excelente", "Bom", "Regular", "Ruim", "Muito ruim"] }

    trait :multipla_escolha do
      tipo { :multipla_escolha }
    end
  end
end