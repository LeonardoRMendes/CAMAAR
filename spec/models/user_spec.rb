require 'rails_helper'

RSpec.describe User, type: :model do

  describe 'associations' do
    it { should have_many(:matriculas).dependent(:destroy) }
    it { should have_many(:respostas).dependent(:destroy) }

    it { should have_many(:turmas).through(:matriculas) }
    it { should have_many(:formularios).through(:avaliacoes) }
    
    it 'has many avaliacoes' do
      association = described_class.reflect_on_association(:avaliacoes)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Avaliacao'
    end
  end
  
  describe 'password' do
    it { should have_secure_password }
  end

  describe 'enums' do
    it { should define_enum_for(:role).with_values(participante: 0, admin: 1) }
  end

  describe 'validations' do
    subject { create(:user) }

    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_confirmation_of(:password) }

    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  describe 'instance methods' do
    describe '#password_set?' do
      it 'returns true when password_digest is present' do
        user = create(:user)
        expect(user.password_set?).to be true
      end

      it 'returns false when password_digest is not present' do
        user = build(:user)
        user.password_digest = nil
        expect(user.password_set?).to be false
      end
    end
  end
end
