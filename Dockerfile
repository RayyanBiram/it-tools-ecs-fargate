# Stage 1: Build Stage

FROM node:18.18.2-alpine AS builder

WORKDIR /app

RUN npm install -g pnpm@10.34.4

COPY app/package.json app/pnpm-lock.yaml ./

RUN pnpm install

COPY app/ ./

RUN pnpm run build

# Stage 2: Production Stage

FROM nginxinc/nginx-unprivileged:alpine

COPY --from=builder /app/dist /usr/share/nginx/html

COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 8080

ENTRYPOINT [ "nginx", "-g", "daemon off;" ]