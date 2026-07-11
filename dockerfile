# ---------- Etapa 1: build ----------
FROM node:20-alpine AS build

WORKDIR /app

# Build-args: URLs de los backends, inyectadas en tiempo de build (Vite las
# reemplaza como texto plano en el bundle final, por eso deben ir aquí y no
# como variable de entorno en runtime del contenedor nginx).
ARG VITE_API_VENTAS_URL
ARG VITE_API_DESPACHOS_URL
ENV VITE_API_VENTAS_URL=${VITE_API_VENTAS_URL}
ENV VITE_API_DESPACHOS_URL=${VITE_API_DESPACHOS_URL}

COPY package*.json ./
RUN npm ci

COPY . .
RUN npm run build

# ---------- Etapa 2: runtime ----------
FROM nginx:1.27-alpine

RUN rm -rf /usr/share/nginx/html/*
COPY --from=build /app/dist /usr/share/nginx/html
COPY nginx.conf /etc/nginx/conf.d/default.conf

EXPOSE 80

CMD ["nginx", "-g", "daemon off;"]
