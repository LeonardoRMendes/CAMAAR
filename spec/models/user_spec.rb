require 'rails_helper'

# Descreve os testes para o modelo User
RSpec.describe User, type: :model do

  # Bloco de testes para as associações do modelo
  describe 'associations' do
    # Testa as associações 'has_many' diretas
    it { should have_many(:matriculas).dependent(:destroy) }
    it { should have_many(:respostas).dependent(:destroy) }

    # Testa as associações 'has_many :through'
    it { should have_many(:turmas).through(:matriculas) }
    it { should have_many(:formularios).through(:avaliacoes) }
    
    # Testa a associação 'has_many :avaliacoes' com suas opções específicas
    it 'has many avaliacoes' do
      association = described_class.reflect_on_association(:avaliacoes)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Avaliacao'
    end
  end
  
  # Bloco de testes para a funcionalidade de senha segura
  describe 'password' do
    it { should have_secure_password }
  end

  # Bloco de testes para o enum de role
  describe 'enums' do
    it { should define_enum_for(:role).with_values(participante: 0, admin: 1) }
  end

  # Bloco de testes para as validações do modelo
  describe 'validations' do
    # Cria um usuário antes dos testes de unicidade
    subject { create(:user) }

    # Testa as validações de presença e unicidade para o email
    it { should validate_presence_of(:email) }
    it { should validate_uniqueness_of(:email) }

    # Testa as validações de senha
    it { should validate_length_of(:password).is_at_least(6) }
    it { should validate_confirmation_of(:password) }

    it 'is valid with valid attributes' do
      user = build(:user)
      expect(user).to be_valid
    end
  end

  # Bloco de testes para os métodos de instância
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
