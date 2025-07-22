require 'rails_helper'

RSpec.describe Turma, type: :model do

  describe 'associations' do
    it 'has many matriculas' do
      association = described_class.reflect_on_association(:matriculas)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end

    it { should have_many(:users).through(:matriculas) }

    it 'has many formularios' do
      association = described_class.reflect_on_association(:formularios)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:nome) }

    it 'is valid with a name' do
      turma = build(:turma, nome: 'Turma de Teste Válida')
      expect(turma).to be_valid
    end

    it 'is invalid without a name' do
      turma = build(:turma, nome: nil)
      expect(turma).not_to be_valid
      expect(turma.errors[:nome]).to include("can't be blank")
    end
  end
end