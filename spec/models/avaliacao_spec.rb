require 'rails_helper'

RSpec.describe Avaliacao, type: :model do
  let(:user) { create(:user) }
  let(:formulario) { create(:formulario) }

  describe 'associations' do
    it { is_expected.to belong_to(:user) }
    it { is_expected.to belong_to(:formulario) }

    it 'has many respostas' do
      association = described_class.reflect_on_association(:respostas)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Resposta'
  end
  end

  describe 'enums' do
    it 'defines the enum for status' do
      should define_enum_for(:status).with_values(pendente: 0, concluida: 1)
    end
  end

  describe 'validations' do
    context 'uniqueness of user and formulario' do
      before do
        create(:avaliacao, user: user, formulario: formulario)
      end

      it 'is invalid with a duplicate user and formulario' do
        duplicate_avaliacao = build(:avaliacao, user: user, formulario: formulario)

        expect(duplicate_avaliacao).not_to be_valid
        expect(duplicate_avaliacao.errors[:user_id]).to include('has already been taken')
      end

      it 'is valid with the same user but a different formulario' do
        another_formulario = create(:formulario)
        avaliacao = build(:avaliacao, user: user, formulario: another_formulario)

        expect(avaliacao).to be_valid
      end

      it 'is valid with the same formulario but a different user' do
        another_user = create(:user)
        avaliacao = build(:avaliacao, user: another_user, formulario: formulario)

        expect(avaliacao).to be_valid
      end
    end
  end
end