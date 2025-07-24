require 'rails_helper'

RSpec.describe Matricula, type: :model do
  let(:user) { create(:user) }
  let(:turma) { create(:turma) }

  describe 'associations' do
    it { should belong_to(:user) }
    it { should belong_to(:turma) }
  end

  describe 'validations' do
    context 'uniqueness of user and turma' do
      before do
        create(:matricula, user: user, turma: turma)
      end

      it 'is invalid with a duplicate user and turma' do
        duplicate_matricula = build(:matricula, user: user, turma: turma)

        expect(duplicate_matricula).not_to be_valid
        expect(duplicate_matricula.errors[:user_id]).to include('has already been taken')
      end

      it 'is valid for the same user in a different turma' do
        another_turma = create(:turma)
        matricula = build(:matricula, user: user, turma: another_turma)

        expect(matricula).to be_valid
      end

      it 'is valid for a different user in the same turma' do
        another_user = create(:user)
        matricula = build(:matricula, user: another_user, turma: turma)

        expect(matricula).to be_valid
      end
    end
  end
end