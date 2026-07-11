# DevOps Frontend - Innovatech Chile

## Descripción

Este repositorio contiene el Frontend del proyecto desarrollado para Innovatech Chile, correspondiente a la Evaluación Parcial N°2 de Introducción a Herramientas DevOps.

El Frontend fue desarrollado con React y Vite, y se encuentra contenedorizado mediante Docker. La aplicación se despliega en una instancia EC2 pública de AWS, siendo el único componente accesible desde Internet.

## Tecnologías utilizadas

- React
- Vite
- Docker
- Nginx
- GitHub Actions
- Docker Hub
- AWS EC2

## Arquitectura del servicio (actualizada — EFT, migración de EC2 a EKS)

El Frontend se compila como una SPA estática servida por Nginx y corre como
Deployment en Amazon EKS, expuesto por un Network Load Balancer propio.
Habla directamente (desde el navegador del usuario) con los NLB de
`back-ventas` y `back-despachos`, cuyas URLs se inyectan en el bundle en
tiempo de build (ver `src/config/api.js` y el `ARG` del `dockerfile`).

```text
Internet
   |
   ├──> NLB frontend  -> Deployment frontend (2-5 réplicas, HPA)
   ├──> NLB back-ventas
   └──> NLB back-despachos
```

### Variables de entorno (build-time, no runtime)

Como es una SPA compilada con Vite, estas variables deben existir **al
momento del `docker build`**, no como variable de entorno del contenedor
en producción:

| Variable | Uso | Valor local (docker-compose) |
|---|---|---|
| `VITE_API_VENTAS_URL` | URL base del backend de ventas | `http://localhost:8081/api/v1/ventas` |
| `VITE_API_DESPACHOS_URL` | URL base del backend de despachos | `http://localhost:8082/api/v1/despachos` |

Para desarrollo local con `npm run dev`, copiar `.env.example` a `.env` y
ajustar los valores.

### Configuración del cluster y autoscaling (HPA)

- **Autoscaling**: `HorizontalPodAutoscaler` (`k8s/30-frontend.yaml`), mínimo
  2 / máximo 5 réplicas, target 60% CPU.
- **Balanceo de carga**: Service `frontend` tipo `LoadBalancer` (NLB).
- Detalle completo del cluster (nodos, VPC, IAM) en `infra/README.md` y
  `infra/eksctl-cluster.yaml` en la raíz del proyecto integrado.
