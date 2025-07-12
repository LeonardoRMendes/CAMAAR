FactoryBot.define do
  factory :resposta do
    conteudo { "Esta é uma resposta de exemplo." }
    association :questao
    association :user
    association :avaliacao
  end
end
