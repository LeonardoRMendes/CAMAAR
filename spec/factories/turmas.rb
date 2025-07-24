FactoryBot.define do
  factory :turma do
    sequence(:nome) { |n| "Disciplina #{n}" }
    sequence(:codigo) { |n| "MAT000#{n}" }
    sequence(:sigaa_id) { |n| "MAT000#{n}-TA-2024-1" }
    ano { 2024 }
    periodo { 1 }

    trait :calculo do
      nome { "Cálculo 1" }
      codigo { "MAT0001" }
      sigaa_id { "MAT0001-TA-2024-1" }
    end

    trait :fisica do
      nome { "Física 1" }
      codigo { "FIS0001" }
      sigaa_id { "FIS0001-TA-2024-1" }
    end
  end
end
