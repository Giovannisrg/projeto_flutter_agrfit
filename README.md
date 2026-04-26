# 💪 AGR Fit

Aplicativo mobile desenvolvido em **Flutter/Dart** para gerenciamento inteligente de treinos, com persistência local, simulação de API com autenticação via token e geração automática de treinos personalizados.

---

# 👥 Integrantes

* Ana Júlia Morais Moreira — RA: 2405838
* Rafaela da Silva — RA: 2411652
* Giovanni S. R. Gemignani — RA: 2411209

---

# 📱 Sobre o Projeto

O **AGR Fit** é um aplicativo que permite ao usuário:

* Criar e gerenciar treinos personalizados
* Executar treinos com cronômetro e controle de exercícios
* Armazenar dados localmente com SQLite
* Simular autenticação com token
* Consumir API REST (simulada)

O foco do projeto é aplicar conceitos reais de desenvolvimento mobile com **arquitetura organizada e escalável**.

---

# ⚙️ Funcionalidades

## 🔐 Autenticação

* Cadastro e login de usuários
* Persistência de sessão com **SharedPreferences**
* Armazenamento de token local

---

## 🏋️ Treinos Inteligentes

* Criação automática baseada em:

  * Objetivo
  * Frequência
  * Professor
* Divisão automática:

  * Push / Pull / Legs
  * Upper / Lower
* Geração sem repetição de exercícios

---

## 📊 Execução de Treino

* Cronômetro em tempo real
* Controle de descanso
* Marcação de exercícios
* Finalização de treino

---

## 👤 Perfil

* Edição de dados do usuário
* Persistência no banco local

---

## 🤖 Chatbot (Simulação)

* Interface de chat
* Assistente de treino simulado

---

## ⚙️ Configurações

* Controle de notificações
* Tela de ajuda e privacidade
* Logout com limpeza de sessão

---

## 🌐 API (Simulada)

* Consumo via HTTP
* Métodos:

  * GET
  * POST
  * PUT
  * DELETE
* Autenticação via **Bearer Token**

---

# 🧠 Arquitetura

```plaintext
lib/
├── pages/        → Interface
├── services/     → API / Auth
├── database/     → DAO / SQLite
├── main.dart
```

### Fluxo:

```plaintext
UI → Services → DAO → Banco
```

---

# 🗄️ Banco de Dados

O aplicativo utiliza **SQLite local**, criado automaticamente ao iniciar o app.

### Tabelas principais:

* usuarios
* treinos
* exercicios
* professores
* objetivos
* frequencias

### Características:

* Criação automática
* Controle de versão
* Seed inicial de dados
* Relacionamento entre entidades

---

## 🔧 Acesso manual (opcional)

Para inspeção ou debug do banco:

```bash
adb pull /data/user/0/com.example.projeto_flutter_agrfit/databases/agrfit.db
sqlite3 agrfit.db
```

Comandos úteis:

```sql
.tables
SELECT * FROM usuarios;
```

---

# 🔐 Autenticação

* Token simulado salvo localmente
* Sessão persistida com SharedPreferences
* Login automático

---

# 🧪 API de Teste

```plaintext
https://jsonplaceholder.typicode.com
```

---

# 🛠️ Tecnologias

* Flutter
* Dart
* SQLite (sqflite)
* SharedPreferences
* HTTP

---

# ▶️ Como Executar

```bash
git clone https://github.com/Giovannisrg/projeto_flutter_agrfit
cd projeto_flutter_agrfit
flutter pub get
flutter run
```

---

# 🔑 Usuário de Teste

```plaintext
Email: admin@email.com
Senha: 123456
```

---

# 🚀 Diferenciais

* Arquitetura em camadas
* Geração automática de treinos
* Execução com cronômetro
* Persistência completa
* Organização profissional

---

# 📌 Objetivo Acadêmico

Aplicar conceitos de:

* Mobile
* Banco de dados
* API
* Autenticação
* Arquitetura

---

# 📄 Licença

Projeto acadêmico para fins educacionais.
