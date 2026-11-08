#!/bin/sh
set -e
cd /opt/homelab
echo "== 1. Guardando estado en git"
git add -A && git commit -qm "Antes de actualizar $(date +%F)" || true
echo "== 2. Guardando copia de las imágenes actuales (etiqueta :anterior)"
for img in $(docker compose config --images); do
  docker tag "$img" "${img%:*}:anterior" 2>/dev/null || true
done
echo "== 3. Descargando versiones nuevas"
docker compose pull
echo "== 4. Aplicando"
docker compose up -d
echo "== 5. Estado"
docker compose ps
echo "Revisa Uptime Kuma en 5 minutos. Si algo falla, usa la marcha atrás."
