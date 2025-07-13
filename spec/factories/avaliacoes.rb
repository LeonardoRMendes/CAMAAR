FactoryBot.define do
  factory :avaliacao do
    association :user
    association :formulario
    status { :pendente }
  end
end
