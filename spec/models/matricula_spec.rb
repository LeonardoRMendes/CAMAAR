require 'rails_helper'

# Descreve os testes para o modelo Matricula
RSpec.describe Matricula, type: :model do
  # Usa FactoryBot para criar dados de teste reutilizáveis
  let(:user) { create(:user) }
  let(:turma) { create(:turma) }

  # Bloco de testes para as associações do modelo
  describe 'associations' do
    # Testa as associações 'belongs_to'
    it { should belong_to(:user) }
    it { should belong_to(:turma) }
  end

  # Bloco de testes para as validações do modelo
  describe 'validations' do
    # Testa a validação de unicidade para a combinação de user_id e turma_id
    context 'uniqueness of user and turma' do
      # Cria uma matrícula válida antes de cada teste neste contexto
      before do
        create(:matricula, user: user, turma: turma)
      end

      it 'is invalid with a duplicate user and turma' do
        # Tenta criar uma segunda matrícula com o mesmo usuário e turma
        duplicate_matricula = build(:matricula, user: user, turma: turma)

        # Espera-se que a matrícula duplicada não seja válida
        expect(duplicate_matricula).not_to be_valid
        # Verifica se a mensagem de erro correta está presente
        expect(duplicate_matricula.errors[:user_id]).to include('has already been taken')
      end

      it 'is valid for the same user in a different turma' do
        # Cria uma segunda turma
        another_turma = create(:turma)
        # Cria uma matrícula para o mesmo usuário, mas em uma turma diferente
        matricula = build(:matricula, user: user, turma: another_turma)

        # Espera-se que esta matrícula seja válida
        expect(matricula).to be_valid
      end

      it 'is valid for a different user in the same turma' do
        # Cria um segundo usuário
        another_user = create(:user)
        # Cria uma matrícula para um usuário diferente na mesma turma
        matricula = build(:matricula, user: another_user, turma: turma)

        # Espera-se que esta matrícula seja válida
        expect(matricula).to be_valid
      end
    end
  end
end