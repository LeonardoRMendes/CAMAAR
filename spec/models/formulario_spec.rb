require 'rails_helper'

# Descreve os testes para o modelo Formulario
RSpec.describe Formulario, type: :model do

  # Bloco de testes para as associações do modelo
  describe 'associations' do
    # Testes para as associações 'belongs_to'
    it { should belong_to(:turma) }
    it { should belong_to(:template) }

    # Testes para as associações 'has_many'
    it { should have_many(:questoes).through(:template) }
    it { should have_many(:users).through(:avaliacoes) }

    # Testa a associação 'has_many :avaliacoes' com suas opções específicas
    it 'has many avaliacoes' do
      association = described_class.reflect_on_association(:avaliacoes)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Avaliacao'
    end
  end

  # Bloco de testes para as validações do modelo
  describe 'validations' do
    # Testa a validação de presença para o atributo 'nome'
    it { should validate_presence_of(:nome) }

    # Teste de exemplo para garantir que um formulário válido pode ser criado
    it 'is valid with a name, turma, and template' do
      # Usa factories para criar os objetos necessários
      turma = create(:turma)
      template = create(:template)
      formulario = build(:formulario, nome: 'Formulário de Teste Válido', turma: turma, template: template)

      # Espera-se que o formulário seja válido
      expect(formulario).to be_valid
    end

    # Teste de exemplo para garantir que um formulário inválido não é salvo
    it 'is invalid without a name' do
      # Constrói um formulário sem nome
      formulario = build(:formulario, nome: nil)

      # Espera-se que o formulário não seja válido
      expect(formulario).not_to be_valid
      # Verifica se a mensagem de erro correta está presente
      expect(formulario.errors[:nome]).to include("can't be blank")
    end
  end
end