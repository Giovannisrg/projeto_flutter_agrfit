# Olá!

Este é um repositório para um projeto acadêmico que foi desenvolvido por três integrantes. Ana, Giovanni e Rafaela.

Sinta-se à vontade para se inspirar neste projeto. Mas não copie nada sem autorização. 

Qualquer contribuição e crítica construtiva é bem-vinda!

---

# AGR Fit

Aplicativo mobile desenvolvido em Flutter/Dart para gerenciamento de treinos, com autenticação de usuários e integração com inteligência artificial para assistência personalizada.

---

## Sobre o Projeto

O AGR Fit é um aplicativo voltado para auxiliar usuários no acompanhamento de seus treinos de forma prática e inteligente. Ele oferece recursos como personalização de treinos, controle de acesso por mensalidade e suporte com inteligência artificial para melhorar a experiência do usuário.

---

## Funcionalidades

- Autenticação de usuários
- Controle de acesso baseado na validade da mensalidade
- CRUD de treinos organizados por dias da semana
- Personalização de treinos:
  - Professor
  - Objetivo
  - Frequência
- Chat com Inteligência Artificial:
  - Dúvidas
  - Recomendações personalizadas
- Exibição de vídeos demonstrativos de exercícios
- Tela de configurações
- Upload de imagens (treino do dia)

---

## Tecnologias Utilizadas

- Flutter
- Dart
- SQLite (armazenamento local)
- API REST
- JWT (autenticação)
- Integração com IA
- Armazenamento de arquivos e imagens

---

## Planejamento Técnico (Cronograma)

| Data       | Conteúdo Técnico |
|------------|-----------------|
| 30/03      | Navegação entre telas |
| 13/04      | SQLite (armazenamento local) |
| 20/04      | API + JWT (autenticação e mensalidade) |
| 27/04      | Integração com IA |
| 04/05      | Processos em background (validação e notificações) |
| 11/05      | Manipulação de arquivos e cache |
| 18/05      | Câmera/Galeria (upload de imagens) |

---

## Estrutura do Projeto 
lib/
├── models/
├── services/
├── screens/
├── widgets/
├── database/
├── utils/
└── main.dart


---

## Regras de Negócio

- Usuários só podem acessar funcionalidades se a mensalidade estiver ativa
- Treinos devem ser organizados por dias da semana
- A IA deve fornecer respostas contextualizadas ao treino do usuário
- Upload de imagens será utilizado para acompanhamento diário

---

## Integrantes

- Ana Júlia Morais Moreira — RA: 2405838  
- Rafaela da Silva — RA: 2411652  
- Giovanni S. R. Gemignani — RA: 2411209  

---

## Objetivo

Desenvolver um aplicativo completo que integre conceitos de:
- Desenvolvimento mobile
- Banco de dados local
- APIs e autenticação
- Inteligência artificial
- Manipulação de arquivos e mídia

---

## Futuras Melhorias

- Integração com dispositivos wearable
- Dashboard com evolução do usuário
- Sistema de notificações inteligentes
- Plano de treino automático via IA

---

## Como Executar o Projeto

1. Clone o repositório:

    ```git clone https://github.com/Giovannisrg/projeto_flutter_agrfit```

2. Acesse a pasta:

    ```cd projeto_flutter_agrfit```

3. Instale as dependências:

    ```flutter pub get```

4. Execute o projeto:

    ```flutter run```

---

## Lincença

<<<<<<< HEAD
Este projeto é acadêmico e desenvolvido para fins educacionais.
=======
Este projeto é acadêmico e desenvolvido para fins educacionais.

## instalar para auth_services:
flutter pub add shared_preferences

## instalar para api_services:
flutter pub add http
>>>>>>> 3907fdf (API e Token simulados de exemplo 2)
