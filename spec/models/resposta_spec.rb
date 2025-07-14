require 'rails_helper'

# Descreve os testes para o modelo Resposta
RSpec.describe Resposta, type: :model do
  # Usa FactoryBot para criar dados de teste reutilizáveis
  let(:user) { create(:user) }
  let(:questao) { create(:questao) }
  let(:avaliacao) { create(:avaliacao, user: user) }

  # Bloco de testes para as associações do modelo
  describe 'associations' do
    # Testa as associações 'belongs_to'
    it { should belong_to(:questao) }
    it { should belong_to(:user) }
    it { should belong_to(:avaliacao) }
  end

  # Bloco de testes para as validações do modelo
  describe 'validations' do
    # Testa a validação de presença para o atributo 'conteudo'
    it { should validate_presence_of(:conteudo) }

    # Testa a validação de unicidade para a combinação de user_id e questao_id
    context 'uniqueness of user and questao' do
      # Cria uma resposta válida antes de cada teste neste contexto
      before do
        create(:resposta, user: user, questao: questao, avaliacao: avaliacao)
      end

      it 'is invalid with a duplicate user and questao' do
        # Tenta criar uma segunda resposta com o mesmo usuário e questão
        duplicate_resposta = build(:resposta, user: user, questao: questao, avaliacao: avaliacao)

        # Espera-se que a resposta duplicada não seja válida
        expect(duplicate_resposta).not_to be_valid
        # Verifica se a mensagem de erro correta está presente
        expect(duplicate_resposta.errors[:user_id]).to include('has already been taken')
      end

      it 'is valid for the same user on a different questao' do
        # Cria uma segunda questão
        another_questao = create(:questao)
        # Cria uma resposta para o mesmo usuário, mas em uma questão diferente
        resposta = build(:resposta, user: user, questao: another_questao, avaliacao: avaliacao)

        # Espera-se que esta resposta seja válida
        expect(resposta).to be_valid
      end

      it 'is valid for a different user on the same questao' do
        # Cria um segundo usuário e sua respectiva avaliação
        another_user = create(:user)
        another_avaliacao = create(:avaliacao, user: another_user, formulario: avaliacao.formulario)
        # Cria uma resposta para um usuário diferente na mesma questão
        resposta = build(:resposta, user: another_user, questao: questao, avaliacao: another_avaliacao)

        # Espera-se que esta resposta seja válida
        expect(resposta).to be_valid
      end
    end
  end
end