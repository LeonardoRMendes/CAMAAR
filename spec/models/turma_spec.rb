require 'rails_helper'

# Descreve os testes para o modelo Turma
RSpec.describe Turma, type: :model do

  # Bloco de testes para as associações do modelo
  describe 'associations' do
    # Testa a associação 'has_many :matriculas' com sua opção de dependência
    it 'has many matriculas' do
      association = described_class.reflect_on_association(:matriculas)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
    
    # Testa a associação 'has_many :users' através de 'matriculas'
    it { should have_many(:users).through(:matriculas) }

    # Testa a associação 'has_many :formularios' com sua opção de dependência
    it 'has many formularios' do
      association = described_class.reflect_on_association(:formularios)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  # Bloco de testes para as validações do modelo
  describe 'validations' do
    # Testa a validação de presença para o atributo 'nome'
    it { should validate_presence_of(:nome) }

    # Teste de exemplo para garantir que uma turma válida pode ser criada
    it 'is valid with a name' do
      turma = build(:turma, nome: 'Turma de Teste Válida')
      expect(turma).to be_valid
    end

    # Teste de exemplo para garantir que uma turma inválida não é salva
    it 'is invalid without a name' do
      turma = build(:turma, nome: nil)
      expect(turma).not_to be_valid
      expect(turma.errors[:nome]).to include("não pode ficar em branco")
    end
  end
end
