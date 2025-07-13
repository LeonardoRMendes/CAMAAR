# Script para garantir matrículas dos usuários de teste

user1 = User.find_by(email: 'usuario1@test.com')
user2 = User.find_by(email: 'usuario2@test.com')

if user1 && user2
  # Garantir que user1 está na turma 9 (onde há formulários)
  turma9 = Turma.find(9)
  Matricula.find_or_create_by(user: user1, turma: turma9)
  Matricula.find_or_create_by(user: user2, turma: turma9)
  
  puts "✅ Usuários matriculados na turma #{turma9.nome}"
  
  # Verificar formulários da turma 9
  formularios_turma9 = Formulario.where(turma: turma9, ativo: true)
  puts "📋 Formulários ativos na turma 9: #{formularios_turma9.count}"
  
  formularios_turma9.each do |formulario|
    [user1, user2].each do |user|
      # Criar avaliação se não existir
      avaliacao = Avaliacao.find_or_create_by(
        user: user, 
        formulario: formulario
      ) do |a|
        a.status = :pendente
      end
      
      puts "🎯 #{user.nome} -> #{formulario.nome}: #{avaliacao.status}"
    end
  end
  
  puts "\n📊 Resultado final:"
  puts "User1 avaliações pendentes: #{user1.avaliacoes.where(status: :pendente).count}"
  puts "User2 avaliações pendentes: #{user2.avaliacoes.where(status: :pendente).count}"
else
  puts "❌ Usuários não encontrados"
end
