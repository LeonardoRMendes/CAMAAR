require 'rails_helper'

# Descreve os testes para o modelo Template
RSpec.describe Template, type: :model do

  # Bloco de testes para as associações do modelo
  describe 'associations' do
    # Testa a associação 'has_many :questoes' com suas opções específicas
    it 'has many questoes' do
      association = described_class.reflect_on_association(:questoes)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Questao'
    end

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

    # Teste de exemplo para garantir que um template válido pode ser criado
    it 'is valid with a name' do
      template = build(:template, nome: 'Template Válido')
      expect(template).to be_valid
    end

    # Teste de exemplo para garantir que um template inválido não é salvo
    it 'is invalid without a name' do
      template = build(:template, nome: nil)
      expect(template).not_to be_valid
      expect(template.errors[:nome]).to include("can't be blank")
    end
  end
end