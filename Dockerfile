FROM node:20.12-alpine

WORKDIR /app

# 🧰 Install required system dependencies
RUN apk add --no-cache libc6-compat python3 make g++

ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"

RUN corepack enable

# 🧩 Copy only package files first (for better caching)
COPY package.json pnpm-lock.yaml ./

# 🧩 Install dependencies
RUN pnpm install --frozen-lockfile

# 🧩 Copy the rest of your app
COPY . .

RUN pnpm build

EXPOSE 3001

CMD ["pnpm", "start", "-H", "0.0.0.0", "-p", "3001"]
