module Import
  class FromJsonFile
    def initialize(file)
      @file = file
      @stats = { turmas: 0, discentes: 0, matriculas: 0 }
    end

    def call
      data = JSON.parse(@file.read)
      
      process_turmas(data['turmas']) if data['turmas']
      process_discentes(data['discentes']) if data['discentes']
      process_matriculas(data['turmas'], data['discentes']) if data['turmas'] && data['discentes']
      
      return { success: true, stats: @stats }
    rescue JSON::ParserError => e
      return { success: false, error: 'JSON inválido' }
    rescue StandardError => e
      return { success: false, error: "Erro ao processar arquivo: #{e.message}" }
    end

    private

    def process_turmas(turmas_data)
      turmas_data.each do |turma_info|
        turma = Turma.find_or_initialize_by(sigaa_id: turma_info['id_turma'])
        if turma.new_record?
          turma.nome = "#{turma_info['codigo_componente']} - #{turma_info['nome_componente']}"
          turma.codigo = turma_info['codigo_componente']
          turma.ano = turma_info['ano']
          turma.periodo = turma_info['periodo']
          turma.save!
          @stats[:turmas] += 1
        end
      end
    end

    def process_discentes(discentes_data)
      discentes_data.each do |discente_info|
        user = User.find_or_initialize_by(email: discente_info['email'])
        if user.new_record?
          user.role = :participante
          user.nome = discente_info['nome'] if discente_info['nome']
          user.matricula = discente_info['matricula'] if discente_info['matricula']
          user.password = SecureRandom.hex(8) # Senha temporária
          user.save!
          
          send_password_setup_email(user)
          
          @stats[:discentes] += 1
        end
      end
    end

    def process_matriculas(turmas_data, discentes_data)
      turmas_data.each do |turma_info|
        turma = Turma.find_by(sigaa_id: turma_info['id_turma'])
        next unless turma

        if turma_info['discentes']
          turma_info['discentes'].each do |discente_matricula|
            discente_data = discentes_data.find { |d| d['matricula'] == discente_matricula }
            next unless discente_data

            user = User.find_by(email: discente_data['email'])
            next unless user

            unless Matricula.exists?(user: user, turma: turma)
              Matricula.create!(user: user, turma: turma)
              @stats[:matriculas] += 1
            end
          end
        end
      end
    end

    def send_password_setup_email(user)
      token = user.signed_id(purpose: "password_setup", expires_in: 15.minutes)
      UserMailer.with(user: user, token: token).password_setup_email.deliver_now
    rescue StandardError => e
      Rails.logger.error "Erro ao enviar e-mail de definição de senha para #{user.email}: #{e.message}"
    end
  end
end
