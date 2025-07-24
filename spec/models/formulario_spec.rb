require 'rails_helper'

RSpec.describe Formulario, type: :model do

  describe 'associations' do
    it { should belong_to(:turma) }
    it { should belong_to(:template) }

    it { should have_many(:questoes).through(:template) }
    it { should have_many(:users).through(:avaliacoes) }

    it 'has many avaliacoes' do
      association = described_class.reflect_on_association(:avaliacoes)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Avaliacao'
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:nome) }

    it 'is valid with a name, turma, and template' do
      turma = create(:turma)
      template = create(:template)
      formulario = build(:formulario, nome: 'Formulário de Teste Válido', turma: turma, template: template)

      expect(formulario).to be_valid
    end

    it 'is invalid without a name' do
      formulario = build(:formulario, nome: nil)

      expect(formulario).not_to be_valid
      expect(formulario.errors[:nome]).to include("can't be blank")
    end
  end
end