require 'rails_helper'

# Descreve os testes para o modelo Avaliacao
RSpec.describe Avaliacao, type: :model do
  # Usa FactoryBot para criar dados de teste reutilizáveis
  let(:user) { create(:user) }
  let(:formulario) { create(:formulario) }

  # Bloco de testes para as associações do modelo
  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:formulario) }
    
    # Testa a associação 'has_many' e suas opções
    it 'has many respostas' do
      association = described_class.reflect_on_association(:respostas)
      expect(association.macro).to eq :has_many
      expect(association.options[:dependent]).to eq :destroy
      expect(association.options[:class_name]).to eq 'Resposta'
    end
  end

  # Bloco de testes para o enum de status
  describe 'enums' do
    # Verifica se o enum 'status' está definido corretamente com os valores esperados
    it 'defines the enum for status' do
      should define_enum_for(:status).with_values(pendente: 0, concluida: 1)
    end
  end

  # Bloco de testes para as validações do modelo
  describe 'validations' do
    # Testa a validação de unicidade para a combinação de user_id e formulario_id
    context 'uniqueness of user and formulario' do
      # Cria uma avaliação válida antes de cada teste neste contexto
      before do
        create(:avaliacao, user: user, formulario: formulario)
      end

      it 'is invalid with a duplicate user and formulario' do
        # Tenta criar uma segunda avaliação com o mesmo usuário e formulário
        duplicate_avaliacao = build(:avaliacao, user: user, formulario: formulario)
        
        # Espera-se que a avaliação duplicada não seja válida
        expect(duplicate_avaliacao).not_to be_valid
        # Verifica se a mensagem de erro correta está presente
        expect(duplicate_avaliacao.errors[:user_id]).to include('já está em uso')
      end

      it 'is valid with the same user but a different formulario' do
        # Cria um segundo formulário
        another_formulario = create(:formulario)
        # Cria uma avaliação com o mesmo usuário, mas um formulário diferente
        avaliacao = build(:avaliacao, user: user, formulario: another_formulario)
        
        # Espera-se que esta avaliação seja válida
        expect(avaliacao).to be_valid
      end

      it 'is valid with the same formulario but a different user' do
        # Cria um segundo usuário
        another_user = create(:user)
        # Cria uma avaliação com o mesmo formulário, mas um usuário diferente
        avaliacao = build(:avaliacao, user: another_user, formulario: formulario)
        
        # Espera-se que esta avaliação seja válida
        expect(avaliacao).to be_valid
      end
    end
  end
end
