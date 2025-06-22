# Wiki - Sprint 1 - Projeto CAMAAR

## 👥 Equipe

| Nome                          | Matrícula    | Função |
|-------------------------------|--------------|-------|
| Leonardo Reis Mendes                | 222001340     | Scrum Master |
| Carlos Eduardo da Silva Almeida             | 180014625     | Dev Team |
| João Lucas Sales Aragão                | 190015225     | Dev Team |
| João Pedro de Lima Araujo                | 211010421     | Product Owner |
| Daniel Toledo Dantas             | 211068477   | Dev Team |

---

## 🎯 Nome do Projeto: CAMAAR (Central de Avaliação de Monitoramento Acadêmico e Avaliação de Resultados)

Sistema web para gestão de avaliações de desempenho de turmas universitárias, integrando dados do SIGAA, com aplicação de questionários anônimos e geração de relatórios.

---

## ✅ Histórias de Usuário contempladas na Sprint 1:

| Issue | História de Usuário |
|---|---|
| #98 | Importar dados de turmas, matérias e participantes do SIGAA |
| #99 | Responder questionário da turma |
| #100 | Cadastrar participantes do SIGAA |
| #101 | Baixar resultados em CSV |
| #102 | Criar template de formulário |
| #103 | Criar formulário baseado em um template |
| #104 | Sistema de login |
| #105 | Definir senha |
| #112 | Editar/deletar templates |
| #111 | Visualizar templates |
| #110 | Visualizar formulários criados |
| #109 | Participante visualizar formulários não respondidos |
| #108 | Atualizar base de dados com dados atuais do SIGAA |

---

## ✅ Regras de Negócio Extraídas das Histórias de Usuário:

### 📌 Importação de dados do SIGAA:
- Administradores podem importar turmas, disciplinas e participantes.
- Dados só são importados se ainda não existirem na base.
- Base pode ser atualizada com os dados mais recentes do SIGAA.

### 📌 Cadastrar participantes:
- Novos participantes são criados a partir da importação.
- Esses participantes podem acessar o sistema após definirem sua senha.

### 📌 Criação de Templates de Formulário:
- Administradores podem criar templates com perguntas do tipo texto ou escala Likert.
- Não é possível criar um template sem nome ou sem questões.

### 📌 Criação de Formulários para Turmas:
- Administradores podem selecionar um template e aplicar em uma ou mais turmas.
- Após o envio, o template desaparece da lista de templates disponíveis para envio.

### 📌 Sistema de Login:
- Login usando e-mail ou matrícula + senha.
- Mensagens claras para erros como "usuário inválido" ou "senha incorreta".

### 📌 Definição de Senha:
- Usuários recebem link por e-mail para definir senha.
- Regras: mínimo de 8 caracteres, confirmação obrigatória.

### 📌 Responder Formulário:
- Participantes só podem ver e responder formulários das turmas em que estão matriculados.
- Sistema registra apenas **se o participante respondeu**, mas **não guarda quem respondeu o quê (anônimo)**.

### 📌 Exportação de Resultados:
- Administradores podem exportar as respostas agregadas de um formulário em formato CSV.
- Sem identificação de quem respondeu.

### 📌 Visualização de Templates e Formulários:
- Administradores podem visualizar templates existentes e os formulários já criados.
- Edição e exclusão de templates **não afeta formulários já enviados**.

### 📌 Participantes visualizando Formulários Pendentes:
- Sistema mostra ao participante apenas os formulários que ele ainda não respondeu.

---

## ✅ Política de Branches (Branching Model - Git Flow)

### Fluxo de Branches:

- **`main`**: Branch principal com a versão de produção mais estável.
- **`develop`**: Branch de desenvolvimento contínuo (não utilizada nesta sprint por restrição do projeto, mas considerada para futuras sprints).
- **Branches de funcionalidade (`feature/*`)**: Criadas para cada nova funcionalidade ou história de usuário.
- **Branch de release (`sprint-1`)**: Branch específica para consolidação da entrega da Sprint 1.
- **Branches de hotfix (`hotfix/*`)**: Criadas para correção emergencial de bugs, se necessário.

### Fluxo adotado para a Sprint 1:

- Fizemos um **fork** do repositório principal.
- Dentro do fork, criamos a branch: **`sprint-1`**
- Cada membro desenvolveu as suas funcionalidades em **branches locais de feature** (exemplo: `feature/login`, `feature/criar-template`, etc).
- As **features foram integradas à branch `sprint-1`** por meio de merges locais ou diretos.
- Ao final da sprint, faremos uma **única Pull Request da branch `sprint-1` para o repositório original**, seguindo o fluxo de integração do Git Flow.

### Exemplo de Branches usadas:

| Tipo de Branch | Nome de Exemplo |
|---|---|
| Branch Principal | `main` |
| Branch de Sprint | `sprint-1` |
| Branches de Feature | `feature/login`, `feature/criar-template`, `feature/definir-senha`, etc |

---

## ✅ Velocity da Sprint:

| Issue | Story Points |
|---|---|
| #98 | 5 |
| #99 | 3 |
| #100 | 3 |
| #101 | 3 |
| #102 | 5 |
| #103 | 5 |
| #104 | 3 |
| #105 | 3 |
| #112 | 2 |
| #111 | 2 |
| #110 | 2 |
| #109 | 2 |
| #108 | 3 |
| **Total** | **41 Story Points** |

---

## ✅ Links importantes:

- [Repositório do Grupo](https://github.com/LeonardoRMendes/CAMAAR)
- [Repositório Principal (EngSwCIC)](https://github.com/EngSwCIC/CAMAAR)
- [Figma / Protótipo de UI](https://www.figma.com/design/5GVzfaJSBbcXmGvuvAi7WF/Camaar-2024.1)

---
