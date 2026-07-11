// Centraliza las URLs de los backends.
// En build time, Vite reemplaza import.meta.env.VITE_* con el valor definido
// como build-arg en el Dockerfile (o en un archivo .env local para `npm run dev`).
// Si no está definida, cae a localhost para desarrollo local con docker-compose.
export const API_VENTAS_URL =
  import.meta.env.VITE_API_VENTAS_URL || "http://localhost:8081/api/v1/ventas";

export const API_DESPACHOS_URL =
  import.meta.env.VITE_API_DESPACHOS_URL || "http://localhost:8082/api/v1/despachos";
