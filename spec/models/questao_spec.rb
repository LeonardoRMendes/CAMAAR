require 'rails_helper'

RSpec.describe Questao, type: :model do
  describe 'associations' do
    it { should belong_to(:template) }
  end

  describe 'enums' do
    it 'define enum tipo com valores string' do
      expect(described_class.tipos).to eq(
        'texto' => 'texto',
        'multipla_escolha' => 'multipla_escolha'
      )
    end
  end

  describe 'validations' do
    it { should validate_presence_of(:texto) }
    it { should validate_presence_of(:tipo) }

    it { should validate_inclusion_of(:obrigatoria).in_array([true, false]) }

    context 'when tipo is multipla_escolha' do
      subject { build(:questao, tipo: :multipla_escolha) }
      it { should validate_presence_of(:opcoes) }
    end

    context 'when tipo is texto' do
      subject { build(:questao, tipo: :texto) }
      it { should_not validate_presence_of(:opcoes) }
    end
  end

  describe 'serialization' do
    it 'serializes a Ruby array into the opcoes attribute' do
      opcoes_array = ["Opção 1", "Opção 2"]
      questao = create(:questao, tipo: :multipla_escolha, opcoes: opcoes_array)

      questao.reload

      expect(questao.opcoes).to be_an(Array)
      expect(questao.opcoes).to eq(opcoes_array)
    end
  end

  describe 'instance methods' do
    let(:template) { create(:template) }
    let(:formulario) { create(:formulario, template: template) }
    let!(:questao) { create(:questao, template: template, tipo: :multipla_escolha) }

    describe '#aggregate_results_for_formulario' do
      it 'correctly aggregates a single response' do
        avaliacao = create(:avaliacao, formulario: formulario, status: :concluida)
        create(:resposta, avaliacao: avaliacao, questao: questao, conteudo: 'Muito bom')

        results = questao.aggregate_results_for_formulario(formulario)
        expect(results).to eq({ "Muito bom" => 1 })
      end

      it 'correctly aggregates multiple different responses' do
        avaliacao1 = create(:avaliacao, formulario: formulario, status: :concluida)
        avaliacao2 = create(:avaliacao, formulario: formulario, status: :concluida)

        create(:resposta, avaliacao: avaliacao1, questao: questao, conteudo: 'Bom')
        create(:resposta, avaliacao: avaliacao2, questao: questao, conteudo: 'Ruim')

        results = questao.aggregate_results_for_formulario(formulario)
        expect(results).to eq({ "Bom" => 1, "Ruim" => 1 })
      end

      it 'correctly aggregates multiple identical responses' do
        avaliacao1 = create(:avaliacao, formulario: formulario, status: :concluida)
        avaliacao2 = create(:avaliacao, formulario: formulario, status: :concluida)

        create(:resposta, avaliacao: avaliacao1, questao: questao, conteudo: 'Bom')
        create(:resposta, avaliacao: avaliacao2, questao: questao, conteudo: 'Bom')

        results = questao.aggregate_results_for_formulario(formulario)
        expect(results).to eq({ "Bom" => 2 })
      end

      it 'does not include responses from pending avaliacoes' do
        avaliacao = create(:avaliacao, formulario: formulario, status: :pendente)
        create(:resposta, avaliacao: avaliacao, questao: questao, conteudo: 'Muito bom')

        results = questao.aggregate_results_for_formulario(formulario)
        expect(results).to be_empty
      end
    end

    describe '#opcoes_lista' do
      it 'returns an empty array when tipo is texto' do
        questao_texto = build(:questao, tipo: :texto)
        expect(questao_texto.opcoes_lista).to eq([])
      end

      it 'returns the custom opcoes when they are present' do
        custom_opcoes = ["Sim", "Não", "Talvez"]
        questao_multipla = build(:questao, tipo: :multipla_escolha, opcoes: custom_opcoes)
        expect(questao_multipla.opcoes_lista).to eq(custom_opcoes)
      end

      it 'returns the default OPCOES_AVALIACAO when opcoes are not set' do
        questao_multipla = build(:questao, tipo: :multipla_escolha, opcoes: nil)
        expect(questao_multipla.opcoes_lista).to eq(Questao::OPCOES_AVALIACAO)
      end
    end
  end
end