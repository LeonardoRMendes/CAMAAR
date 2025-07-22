FactoryBot.define do
  factory :formulario do
    nome { "Avaliação de Meio de Semestre" }
    association :turma
    association :template
  end
end
