#!/usr/bin/env ruby

# Script para corrigir avaliações dos usuários de teste
require_relative 'config/environment'

puts "🔧 Corrigindo avaliações dos usuários de teste..."

# Buscar usuários de teste
user1 = User.find_by(email: 'usuario1@test.com')
user2 = User.find_by(email: 'usuario2@test.com')

if user1.nil? || user2.nil?
  puts "❌ Usuários de teste não encontrados!"
  exit 1
end

puts "✅ Usuários encontrados:"
puts "- User1: #{user1.nome} (ID: #{user1.id})"
puts "- User2: #{user2.nome} (ID: #{user2.id})"

# Buscar turmas das quais os usuários fazem parte
turmas_user1 = user1.turmas
turmas_user2 = user2.turmas

puts "\n📚 Turmas dos usuários:"
puts "User1 está em: #{turmas_user1.map(&:nome).join(', ')}"
puts "User2 está em: #{turmas_user2.map(&:nome).join(', ')}"

# Buscar formulários ativos
formularios_ativos = Formulario.where(ativo: true)
puts "\n📋 Formulários ativos encontrados: #{formularios_ativos.count}"

# Criar avaliações pendentes para usuários de teste
avaliacoes_criadas = 0

formularios_ativos.each do |formulario|
  [user1, user2].each do |user|
    # Verificar se o usuário está na turma do formulário
    next unless user.turmas.include?(formulario.turma)
    
    # Verificar se já existe avaliação
    avaliacao_existente = Avaliacao.find_by(user: user, formulario: formulario)
    
    if avaliacao_existente
      puts "⚠️  Avaliação já existe: #{user.nome} -> #{formulario.nome}"
    else
      # Criar nova avaliação
      Avaliacao.create!(
        user: user,
        formulario: formulario,
        status: :pendente
      )
      
      puts "✅ Avaliação criada: #{user.nome} -> #{formulario.nome} (Turma: #{formulario.turma.nome})"
      avaliacoes_criadas += 1
    end
  end
end

puts "\n📊 Resultado:"
puts "- Avaliações criadas: #{avaliacoes_criadas}"
puts "- User1 tem #{user1.avaliacoes.where(status: :pendente).count} avaliações pendentes"
puts "- User2 tem #{user2.avaliacoes.where(status: :pendente).count} avaliações pendentes"

puts "\n🎉 Correção concluída!"
