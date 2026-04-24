# Guia de Banco de Dados - AGR Fit (SQLite)

Este projeto utiliza **SQLite local** integrado ao Flutter.

---

# Como funciona o banco

* O banco é criado automaticamente ao abrir o app
* Nome do arquivo: `agrfit.db`
* Local: armazenamento interno do emulador

---

# Estrutura do banco

## Tabela: usuarios

| Campo          | Tipo     | Descrição              |
| -------------- | -------- | ---------------------- |
| id             | INTEGER  | ID do usuário          |
| nome           | TEXT     | Nome                   |
| email          | TEXT     | Email (único)          |
| senha          | TEXT     | Senha                  |
| data_criacao   | DATETIME | Data de criação        |
| data_expiracao | DATETIME | Controle de assinatura |

---

# ▶Como rodar o projeto

```bash
flutter pub get
flutter run
```

---

# Como testar cadastro

1. Abra o app
2. Clique em **Criar conta**
3. Preencha:

   * Nome
   * Email
   * Senha
4. Confirme cadastro

---

# Como testar login

Use o usuário criado ou:

```
Email: admin@email.com
Senha: 123456
```

---

# Como limpar o banco

```bash
adb uninstall com.example.projeto_flutter_agrfit
flutter run
```

---

# Como extrair o banco (ADB)

```bash
adb root
adb pull /data/user/0/com.example.projeto_flutter_agrfit/databases/agrfit.db
```

---

# Como visualizar no terminal

Abrir banco:

```bash
sqlite3 agrfit.db
```

Comandos úteis:

```sql
.tables
SELECT * FROM usuarios;
```

---

# Exemplo de saída

```
1|Admin|admin@email.com|123456
2|Teste|teste@teste.com|123456
```

---

# ⚠️ Problemas comuns

### Banco vazio

* Você não cadastrou usuário ainda
* Ou puxou o banco antes de cadastrar

### Permission denied

* Rode `adb root` antes

### adb não reconhecido

* Adicione ao PATH ou use `.\adb`
..
