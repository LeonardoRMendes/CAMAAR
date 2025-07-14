require 'rails_helper'

RSpec.describe Template, type: :model do

  describe 'associations' do
    it 'has many questoes' do
      association = described_class.reflect_on_association(:questoes)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Questao'
    end

    it 'has many formularios' do
      association = described_class.reflect_on_association(:formularios)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:nome) }

    it 'is valid with a name' do
      template = build(:template, nome: 'Template Válido')
      expect(template).to be_valid
    end

    it 'is invalid without a name' do
      template = build(:template, nome: nil)
      expect(template).not_to be_valid
      expect(template.errors[:nome]).to include("can't be blank")
    end
  end
end