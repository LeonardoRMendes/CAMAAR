FactoryBot.define do
  factory :user do
    sequence(:email) { |n| "usuario#{n}@unb.br" }
    password { "senha123" }
    password_confirmation { "senha123" }
    nome { "Nome do Usuário" }
    sequence(:matricula) { |n| "20240000#{n}" }
    role { :participante }
    
    trait :without_password do
      password { nil }
      password_confirmation { nil }
      password_digest { nil }
    end
  end
end
