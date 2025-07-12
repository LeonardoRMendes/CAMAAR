Rails.application.configure do
end

puts "Creating test template..."
template = Template.create!(nome: "Test Template")
questao = Questao.create!(template: template, texto: "Test question", obrigatoria: false)

puts "Template created: #{template.nome}"
puts "Questions count: #{template.questoes.count}"

turma = Turma.create!(codigo: "TEST123", nome: "Test Class", ano: 2025, periodo: 1)
formulario = Formulario.create!(nome: "Test Form", turma: turma, template: template)

puts "Formulario created: #{formulario.nome}"
puts "Template has formularios: #{template.formularios.exists?}"

if template.formularios.exists?
  puts "Cannot delete template - it's in use"
else
  puts "Template can be deleted"
end
