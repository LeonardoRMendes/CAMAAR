require 'rails_helper'

RSpec.describe Resposta, type: :model do
  let(:user) { create(:user) }
  let(:questao) { create(:questao) }
  let(:avaliacao) { create(:avaliacao, user: user) }

  describe 'associations' do
    it { should belong_to(:questao) }
    it { should belong_to(:user) }
    it { should belong_to(:avaliacao) }
  end

  describe 'validations' do
    it { should validate_presence_of(:conteudo) }

    context 'uniqueness of user and questao' do
      before do
        create(:resposta, user: user, questao: questao, avaliacao: avaliacao)
      end

      it 'is invalid with a duplicate user and questao' do
        duplicate_resposta = build(:resposta, user: user, questao: questao, avaliacao: avaliacao)

        expect(duplicate_resposta).not_to be_valid
        expect(duplicate_resposta.errors[:user_id]).to include('has already been taken')
      end

      it 'is valid for the same user on a different questao' do
        another_questao = create(:questao)
        resposta = build(:resposta, user: user, questao: another_questao, avaliacao: avaliacao)

        expect(resposta).to be_valid
      end

      it 'is valid for a different user on the same questao' do
        another_user = create(:user)
        another_avaliacao = create(:avaliacao, user: another_user, formulario: avaliacao.formulario)
        resposta = build(:resposta, user: another_user, questao: questao, avaliacao: another_avaliacao)

        expect(resposta).to be_valid
      end
    end
  end
end