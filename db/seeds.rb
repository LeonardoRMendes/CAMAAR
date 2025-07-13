# Limpar dados existentes
User.destroy_all
Template.destroy_all
Turma.destroy_all
Formulario.destroy_all

puts "Criando usuários..."

# Criar admin (conforme README)
admin = User.create!(
  email: 'admin@unb.br',
  nome: 'Administrador',
  role: 'admin',
  password: 'admin123',
  password_confirmation: 'admin123'
)

# Criar usuário comum (conforme README)
user = User.create!(
  email: 'user@unb.br',
  nome: 'João Silva',
  role: 'participante',
  password: 'user123',
  password_confirmation: 'user123'
)

puts "Admin criado: #{admin.email}"
puts "User criado: #{user.email}"

# Criar templates de teste
template1 = Template.create!(nome: 'Feedback Semestral', descricao: 'Template para avaliação semestral')
template1.questoes.create!(
  texto: 'Como você avalia a disciplina?', 
  obrigatoria: true, 
  tipo: 'multipla_escolha',
  opcoes: ['Muito Bom', 'Bom', 'Normal', 'Ruim', 'Muito Ruim']
)
template1.questoes.create!(texto: 'Sugestões de melhoria?', obrigatoria: false, tipo: 'texto')

template2 = Template.create!(nome: 'Avaliação Docente', descricao: 'Template para avaliação do professor')
template2.questoes.create!(
  texto: 'Como você avalia a didática do professor?', 
  obrigatoria: true, 
  tipo: 'multipla_escolha',
  opcoes: ['Muito Bom', 'Bom', 'Normal', 'Ruim', 'Muito Ruim']
)

template3 = Template.create!(nome: 'Template em Uso', descricao: 'Este template está sendo usado')
template3.questoes.create!(texto: 'Questão de exemplo', obrigatoria: false, tipo: 'texto')

# Criar turma
turma = Turma.create!(codigo: 'TST123', nome: 'Turma de Teste', ano: 2025, periodo: 1)
turma.users << user

# Criar formulário
formulario = Formulario.create!(nome: 'Formulário Teste', turma: turma, template: template3)

# Criar avaliação pendente
Avaliacao.create!(
  user: user,
  formulario: formulario,
  status: :pendente
)

puts "✅ Dados de teste criados:"
puts "👤 Admin: admin@unb.br / admin123"
puts "👤 User: user@unb.br / user123"
puts "📝 Templates criados: #{Template.count}"
puts "👥 Usuário associado à turma '#{turma.nome}'"
puts "📋 Template '#{template3.nome}' está em uso"
puts ""
puts "🌐 Acesse: http://localhost:3000/login"
