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


# =========================
#   StrongPack Dummy Payment App
#   Production Dockerfile
# =========================
FROM node:20.12-alpine AS builder

# نصب ابزارهای پایه
RUN apk update && apk add --no-cache libc6-compat

# تنظیم مسیر کار
WORKDIR /app

# فعال‌سازی pnpm
ENV PNPM_HOME="/pnpm"
ENV PATH="$PNPM_HOME:$PATH"
RUN corepack enable

# کپی فایل‌ها
COPY . .

# نصب وابستگی‌ها
RUN pnpm install --frozen-lockfile

# بیلد app برای production
RUN pnpm build


# =========================
#   مرحله نهایی
# =========================
FROM node:20.12-alpine
WORKDIR /app

ENV NODE_ENV=production \
    PNPM_HOME="/pnpm" \
    PATH="$PNPM_HOME:$PATH" \
    PORT=3001 \
    HOST=0.0.0.0

COPY --from=builder /app .  

EXPOSE 3001

# اجرای نهایی
CMD ["pnpm", "start"]
