FactoryBot.define do
  factory :matricula do
    association :user
    association :turma
  end
end
