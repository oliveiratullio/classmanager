# Estágio de dependências
FROM node:20-alpine AS deps
WORKDIR /app

# Instalar pnpm
RUN npm install -g pnpm@latest

# Copiar arquivos de dependências
COPY package.json pnpm-lock.yaml ./

# Instalar dependências
RUN pnpm install --frozen-lockfile --prod=false

# Estágio de build
FROM node:20-alpine AS build
WORKDIR /app

# Instalar pnpm
RUN npm install -g pnpm@latest

# Copiar dependências do estágio anterior
COPY --from=deps /app/node_modules ./node_modules

# Copiar arquivos necessários para o build
COPY package.json pnpm-lock.yaml ./
COPY tsconfig*.json ./
COPY nest-cli.json ./
COPY src/ ./src/

# Executar build
RUN pnpm run build

# Estágio de produção
FROM node:20-alpine AS production
WORKDIR /app

# Instalar pnpm para produção
RUN npm install -g pnpm@latest

# Copiar apenas dependências de produção
COPY package.json pnpm-lock.yaml ./
RUN pnpm install --frozen-lockfile --prod && pnpm store prune

# Copiar arquivos compilados
COPY --from=build /app/dist ./dist

# Configurar usuário não-root para segurança
RUN addgroup -g 1001 -S nodejs && \
    adduser -S nestjs -u 1001
USER nestjs

# Configurar variáveis de ambiente
ENV NODE_ENV=production
ENV PORT=3000

# Expor porta
EXPOSE 3000

# Comando de inicialização
CMD ["node", "dist/main.js"]
