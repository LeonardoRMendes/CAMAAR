admin = User.find_or_create_by(email: 'admin@test.com') do |user|
  user.password = 'password123'
  user.password_confirmation = 'password123'
  user.role = :admin
  user.nome = 'Administrador'
end

Template.destroy_all
Turma.destroy_all
Formulario.destroy_all

template1 = Template.create!(nome: 'Feedback Semestral', descricao: 'Template para avaliação semestral')
template1.questoes.create!(texto: 'Como você avalia a disciplina?', obrigatoria: true)
template1.questoes.create!(texto: 'Sugestões de melhoria?', obrigatoria: false)

template2 = Template.create!(nome: 'Avaliação Docente', descricao: 'Template para avaliação do professor')
template2.questoes.create!(texto: 'Como você avalia a didática do professor?', obrigatoria: true)

template3 = Template.create!(nome: 'Template em Uso', descricao: 'Este template está sendo usado')
template3.questoes.create!(texto: 'Questão de exemplo', obrigatoria: false)

turma = Turma.create!(codigo: 'TST123', nome: 'Turma de Teste', ano: 2025, periodo: 1)
formulario = Formulario.create!(nome: 'Formulário Teste', turma: turma, template: template3)

puts "✅ Dados de teste criados:"
puts "👤 Admin: admin@test.com / password123"
puts "📝 Templates criados: #{Template.count}"
puts "📋 Template '#{template3.nome}' está em uso (não pode ser deletado)"
puts ""
puts "🌐 Acesse: http://localhost:3000/login"
puts "📊 Templates: http://localhost:3000/admin/templates"
