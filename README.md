# AgrFit

Aplicativo mobile desenvolvido em Flutter com foco em organização de treinos, gerenciamento de exercícios e experiência personalizada para usuários de academia. O projeto utiliza armazenamento local com SQLite, autenticação de usuários, notificações e integração com serviços externos.

## Visão Geral

O AgrFit foi desenvolvido para centralizar funcionalidades relacionadas à rotina de treinos em um único aplicativo. A aplicação permite autenticação de usuários, gerenciamento de perfis, criação de treinos personalizados, organização de exercícios e interação com um chatbot assistente.

O projeto segue uma estrutura modular, separando responsabilidades entre páginas, serviços, banco de dados e objetos de transferência de dados (DTOs), facilitando manutenção e escalabilidade.

## Funcionalidades

* Autenticação de usuários
* Persistência de sessão com JWT
* Cadastro e edição de perfil
* Criação e gerenciamento de treinos
* Organização de exercícios por grupos musculares
* Armazenamento local utilizando SQLite
* Sistema de notificações locais
* Tema claro e escuro
* Chatbot integrado para suporte ao usuário
* Splash screen personalizada
* Navegação por barra inferior

## Tecnologias Utilizadas

### Framework

* Flutter
* Dart

### Gerenciamento e Persistência

* SQLite (`sqflite`)
* Shared Preferences
* JWT Decoder

### Comunicação e Serviços

* HTTP
* APIs REST

### Recursos Adicionais

* Awesome Notifications
* Flutter Native Splash
* Flutter Launcher Icons

## Estrutura do Projeto

```text
lib/
├── database/
│   ├── db_helper.dart
│   ├── exercicio_dao.dart
│   ├── listas_dao.dart
│   ├── treino_dao.dart
│   └── tables.sql
│
├── dto/
│   └── auth_response_dto.dart
│
├── pages/
│   ├── chatbot.dart
│   ├── configuracao.dart
│   ├── navbar.dart
│   ├── perfil.dart
│   ├── register_page.dart
│   └── treino.dart
│
├── services/
│   ├── api_service.dart
│   ├── auth_service.dart
│   ├── chat_service.dart
│   └── notification_service.dart
│
├── app_theme.dart
└── main.dart
```

## Arquitetura

O projeto foi organizado em camadas para melhorar legibilidade e manutenção:

* `pages/`: telas e componentes principais da interface.
* `services/`: comunicação com APIs, autenticação e notificações.
* `database/`: acesso ao banco local e operações de persistência.
* `dto/`: objetos de transferência de dados.
* `assets/`: imagens, ícones e recursos visuais.

## Requisitos

Antes de iniciar o projeto, verifique se o ambiente possui:

* Flutter SDK 3.x+
* Dart SDK
* Android Studio ou VS Code
* Emulador Android/iOS ou dispositivo físico

## Instalação

### 1. Clone o repositório

```bash
git clone <URL_DO_REPOSITORIO>
```

### 2. Acesse a pasta do projeto

```bash
cd projeto_flutter_agrfit
```

### 3. Instale as dependências

```bash
flutter pub get
```

### 4. Execute o aplicativo

```bash
flutter run
```

## Configuração do Projeto

### Banco de Dados

O aplicativo utiliza SQLite para armazenamento local. As tabelas e scripts de inicialização estão localizados em:

```text
lib/database/tables.sql
```

### Notificações

As notificações locais são gerenciadas através do pacote `awesome_notifications`.

### Tema

O aplicativo possui suporte a tema claro e escuro, com persistência local utilizando `SharedPreferences`.

## Assets

Os recursos visuais utilizados no projeto estão organizados em:

```text
assets/images/
```

Incluindo:

* Ícone do aplicativo
* Splash screen
* Banners da tela inicial

## Dependências Principais

```yaml
dependencies:
  flutter:
    sdk: flutter
  http: ^1.6.0
  path: ^1.9.1
  shared_preferences: ^2.5.5
  sqflite: ^2.4.2
  jwt_decoder: ^2.0.1
  awesome_notifications: ^0.10.1
```

## Qualidade de Código

O projeto utiliza:

* `flutter_lints`
* Organização modular
* Separação de responsabilidades
* Persistência desacoplada via DAO

## Build de Produção

### Android

```bash
flutter build apk --release
```

ou

```bash
flutter build appbundle --release
```

### iOS

```bash
flutter build ios --release
```

## Roadmap

Possíveis melhorias futuras:

* Integração com backend em nuvem
* Sincronização entre dispositivos
* Histórico completo de treinos
* Dashboard de evolução física
* Integração com wearables
* Sistema avançado de métricas
* Upload de imagens de progresso
* Modo offline avançado

## Contribuição

Contribuições são bem-vindas.

Para contribuir:

1. Faça um fork do projeto
2. Crie uma branch para sua feature
3. Commit suas alterações
4. Envie um pull request

## Convenções

Recomendações utilizadas no projeto:

* Nomenclatura padronizada
* Separação por domínio
* Componentização de telas
* Persistência isolada em DAOs
* Serviços desacoplados da interface

## Licença

Este projeto está disponível para fins acadêmicos e de estudo.

## Autores

Ana Julia Morais |
Giovanni Santiago |
Rafaela da Silva
