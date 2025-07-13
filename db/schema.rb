# This file is auto-generated from the current state of the database. Instead
# of editing this file, please use the migrations feature of Active Record to
# incrementally modify your database, and then regenerate this schema definition.
#
# This file is the source Rails uses to define your schema when running `bin/rails
# db:schema:load`. When creating a new database, `bin/rails db:schema:load` tends to
# be faster and is potentially less error prone than running all of your
# migrations from scratch. Old migrations may fail to apply correctly if those
# migrations use external dependencies or application code.
#
# It's strongly recommended that you check this file into your version control system.

ActiveRecord::Schema[8.0].define(version: 2025_07_13_143948) do
  create_table "avaliacaos", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "formulario_id", null: false
    t.integer "status", default: 0
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["formulario_id"], name: "index_avaliacaos_on_formulario_id"
    t.index ["user_id", "formulario_id"], name: "index_avaliacaos_on_user_id_and_formulario_id", unique: true
    t.index ["user_id"], name: "index_avaliacaos_on_user_id"
  end

  create_table "formularios", force: :cascade do |t|
    t.string "nome", null: false
    t.text "descricao"
    t.boolean "ativo", default: true
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "template_id"
    t.index ["template_id"], name: "index_formularios_on_template_id"
    t.index ["turma_id"], name: "index_formularios_on_turma_id"
  end

  create_table "matriculas", force: :cascade do |t|
    t.integer "user_id", null: false
    t.integer "turma_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.index ["turma_id"], name: "index_matriculas_on_turma_id"
    t.index ["user_id", "turma_id"], name: "index_matriculas_on_user_id_and_turma_id", unique: true
    t.index ["user_id"], name: "index_matriculas_on_user_id"
  end

  create_table "questaos", force: :cascade do |t|
    t.string "texto", null: false
    t.string "tipo", default: "text"
    t.boolean "obrigatoria", default: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "template_id"
    t.text "opcoes"
    t.index ["template_id"], name: "index_questaos_on_template_id"
  end

  create_table "respostas", force: :cascade do |t|
    t.text "conteudo", null: false
    t.integer "questao_id", null: false
    t.integer "user_id", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "avaliacao_id", null: false
    t.index ["avaliacao_id"], name: "index_respostas_on_avaliacao_id"
    t.index ["questao_id"], name: "index_respostas_on_questao_id"
    t.index ["user_id", "questao_id"], name: "index_respostas_on_user_id_and_questao_id", unique: true
    t.index ["user_id"], name: "index_respostas_on_user_id"
  end

  create_table "templates", force: :cascade do |t|
    t.string "nome", null: false
    t.text "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
  end

  create_table "turmas", force: :cascade do |t|
    t.string "nome", null: false
    t.string "codigo", null: false
    t.text "descricao"
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.string "sigaa_id"
    t.integer "ano"
    t.integer "periodo"
    t.index ["codigo"], name: "index_turmas_on_codigo", unique: true
    t.index ["sigaa_id"], name: "index_turmas_on_sigaa_id", unique: true
  end

  create_table "users", force: :cascade do |t|
    t.string "email", null: false
    t.string "password_digest", null: false
    t.datetime "created_at", null: false
    t.datetime "updated_at", null: false
    t.integer "role", default: 0
    t.string "nome"
    t.string "matricula"
    t.index ["email"], name: "index_users_on_email", unique: true
    t.index ["matricula"], name: "index_users_on_matricula", unique: true
  end

  add_foreign_key "avaliacaos", "formularios"
  add_foreign_key "avaliacaos", "users"
  add_foreign_key "formularios", "templates"
  add_foreign_key "formularios", "turmas"
  add_foreign_key "matriculas", "turmas"
  add_foreign_key "matriculas", "users"
  add_foreign_key "questaos", "templates"
  add_foreign_key "respostas", "avaliacaos"
  add_foreign_key "respostas", "questaos"
  add_foreign_key "respostas", "users"
end
