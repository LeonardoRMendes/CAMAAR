FactoryBot.define do
  factory :questao do
    texto { "Qual é sua opinião sobre a disciplina?" }
    tipo { "text" }
    obrigatoria { false }
    association :template
  end
end
