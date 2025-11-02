# FROM node:20.12-alpine
# RUN apk update
# RUN apk add --no-cache libc6-compat
# WORKDIR /app

# ENV PNPM_HOME="/pnpm"
# ENV PATH="$PNPM_HOME:$PATH"
# RUN corepack enable

# COPY . .

# RUN pnpm install --frozen-lockfile

# CMD pnpm dev 


FROM node:20.12-alpine

WORKDIR /app
RUN apk add --no-cache libc6-compat
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

COPY . .
RUN pnpm install --frozen-lockfile
RUN pnpm build

EXPOSE 3001
ENV PORT=3001
# CMD ["pnpm", "start"]
CMD ["pnpm", "start", "-H", "0.0.0.0", "-p", "3001"]

