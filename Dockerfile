FROM node:20.12-alpine

WORKDIR /app

# 🧰 Install build dependencies (for ioredis / hiredis)
RUN apk add --no-cache libc6-compat python3 make g++

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable && corepack prepare pnpm@9.2.0 --activate

# 🧩 Copy package files for caching
COPY package.json pnpm-lock.yaml ./

# 🧩 Install dependencies (with native build support)
RUN pnpm install --frozen-lockfile

# 🧩 Copy app source after dependencies are cached
COPY . .

RUN pnpm build

EXPOSE 3001

CMD ["pnpm", "start", "-H", "0.0.0.0", "-p", "3001"]
