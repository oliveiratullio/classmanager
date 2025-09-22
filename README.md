# 🎓 ClassManager

Sistema de gerenciamento de horários acadêmicos desenvolvido com NestJS e PostgreSQL.

## 📋 Sobre o Projeto

O ClassManager é uma API REST que permite gerenciar e consultar informações sobre horários de aulas, disponibilidade de salas e carga horária de professores em uma instituição de ensino.

### ✨ Funcionalidades

- 📊 **Analytics de Professores**: Consulta de carga horária semanal por professor
- 🏢 **Disponibilidade de Salas**: Verificação de horários livres e ocupados por sala
- 🗓️ **Gestão de Horários**: Sistema completo de agendamento de aulas
- 🏛️ **Estrutura Acadêmica**: Gerenciamento de departamentos, disciplinas e pré-requisitos

## 🛠️ Tecnologias

- **Backend**: NestJS (Node.js + TypeScript)
- **Banco de Dados**: PostgreSQL 16
- **ORM**: TypeORM
- **Gerenciador de Pacotes**: pnpm
- **Containerização**: Docker + Docker Compose
- **Interface Web**: Adminer (para administração do banco)

## 🚀 Como Executar

### Pré-requisitos

- Docker e Docker Compose instalados
- Git

### 1. Clone o repositório

```bash
git clone <url-do-repositorio>
cd classmanager
```

### 2. Execute com Docker Compose

```bash
docker-compose up --build
```

### 3. Acesse os serviços

- **API**: http://localhost:3000
- **Adminer** (Interface do Banco): http://localhost:8080
  - Servidor: `db`
  - Usuário: `uni`
  - Senha: `uni`
  - Base de dados: `universidade`

## 📚 Estrutura do Banco de Dados

### Entidades Principais

- **Department**: Departamentos acadêmicos
- **Professor**: Professores com títulos e departamentos
- **Subject**: Disciplinas com códigos e pré-requisitos
- **Class**: Turmas específicas de disciplinas
- **Building/Room**: Prédios e salas de aula
- **ClassSchedule**: Horários das aulas

### Relacionamentos

```
Department (1) ←→ (N) Professor
Department (1) ←→ (N) Subject
Professor (1) ←→ (N) Subject
Subject (1) ←→ (N) Class
Class (1) ←→ (N) ClassSchedule
Building (1) ←→ (N) Room
Room (1) ←→ (N) ClassSchedule
```

## 🔌 API Endpoints

### Analytics

#### 1. Horários dos Professores
```http
GET /analytics/professors-hours
```

**Resposta:**
```json
[
  {
    "professor_id": 1,
    "professor": "Professor Girafales",
    "hours_per_week": 3.0
  }
]
```

#### 2. Disponibilidade de Salas
```http
GET /analytics/rooms-availability
```

**Parâmetros:**
- `dayOfWeek` (opcional): Dia da semana (1-7, onde 1=Segunda)
- `start` (opcional): Horário de início (padrão: 08:00:00)
- `end` (opcional): Horário de fim (padrão: 22:00:00)

**Exemplos:**
```bash
# Todas as salas, todos os dias
GET /analytics/rooms-availability

# Apenas segunda-feira
GET /analytics/rooms-availability?dayOfWeek=1

# Horário específico
GET /analytics/rooms-availability?dayOfWeek=1&start=09:00:00&end=17:00:00
```

**Resposta:**
```json
[
  {
    "room_id": 1,
    "day_of_week": 1,
    "start_time": "08:00:00",
    "end_time": "09:30:00",
    "status": "occupied"
  },
  {
    "room_id": 1,
    "day_of_week": 1,
    "start_time": "09:30:00",
    "end_time": "11:00:00",
    "status": "free"
  }
]
```

## 🗂️ Estrutura do Projeto

```
classmanager/
├── src/
│   ├── analytics/           # Módulo de analytics
│   │   ├── analytics.controller.ts
│   │   ├── analytics.service.ts
│   │   └── analytics.module.ts
│   ├── app.module.ts        # Módulo principal
│   └── main.ts             # Ponto de entrada
├── db/
│   └── init/
│       ├── 01_schema.sql   # Schema do banco
│       └── 02_seed.sql     # Dados iniciais
├── docker-compose.yml      # Configuração dos containers
├── Dockerfile             # Imagem da aplicação
├── .env.example           # Variáveis de ambiente
└── package.json           # Dependências do projeto
```

## 🔧 Configuração

### Variáveis de Ambiente

O arquivo `.env.example` contém as configurações necessárias:

```env
# Configurações da aplicação
NODE_ENV=development
PORT=3000

# Configurações do banco de dados PostgreSQL
DB_HOST=db
DB_PORT=5432
DB_USERNAME=uni
DB_PASSWORD=uni
DB_DATABASE=universidade

# Configurações de conexão com o banco
TYPEORM_CONNECTION=postgres
TYPEORM_HOST=db
TYPEORM_PORT=5432
TYPEORM_USERNAME=uni
TYPEORM_PASSWORD=uni
TYPEORM_DATABASE=universidade
TYPEORM_SYNCHRONIZE=false
TYPEORM_LOGGING=true
```

## 📊 Dados de Exemplo

O sistema vem com dados de exemplo incluindo:

- **3 Departamentos**: Matemática, Computação, Letras
- **4 Professores**: Com diferentes títulos e departamentos
- **4 Disciplinas**: MAT101, MAT202, INF101, INF202
- **3 Salas**: A-101, A-102, B-201
- **Horários**: Aulas distribuídas ao longo da semana

## 🧪 Testando a API

### Usando curl

```bash
# Horários dos professores
curl http://localhost:3000/analytics/professors-hours

# Disponibilidade de salas
curl http://localhost:3000/analytics/rooms-availability

# Salas na segunda-feira
curl "http://localhost:3000/analytics/rooms-availability?dayOfWeek=1"
```

### Usando Postman

1. Importe a collection (se disponível)
2. Configure a base URL: `http://localhost:3000`
3. Execute as requisições

## 🐳 Docker

### Build da Imagem

```bash
docker build -t classmanager-api .
```

### Executar Apenas o Banco

```bash
docker-compose up db
```

### Logs

```bash
# Ver logs de todos os serviços
docker-compose logs

# Ver logs apenas da API
docker-compose logs api

# Seguir logs em tempo real
docker-compose logs -f api
```

## 🔍 Desenvolvimento

### Scripts Disponíveis

```bash
# Desenvolvimento
pnpm run start:dev

# Build
pnpm run build

# Produção
pnpm run start:prod

# Testes
pnpm run test

# Lint
pnpm run lint
```

### Estrutura de Desenvolvimento

- **TypeScript**: Tipagem estática
- **ESLint + Prettier**: Formatação e qualidade de código
- **Jest**: Framework de testes
- **Multi-stage Docker**: Build otimizado para produção
