#!/usr/bin/env bash

set -euo pipefail
trap "echo 'Error o salida forzada, limpiando...'; rm -f out/tmp_*" EXIT


if [[ -z "${TARGETS:-}" ]]; then
  echo "Debes definir TARGETS (ej: export TARGETS='https://example.com https://openai.com')" >&2
  exit 1
fi

HEADERS=("Strict-Transport-Security" "Content-Security-Policy" "X-Content-Type-Options" "Access-Control-Allow-Origin")

for url in $TARGETS; do
  host=$(echo "$url" | awk -F/ '{print $3}')
  file="out/headers_${host}.txt"
  echo "Consultando $url ..."
  curl -s -I "$url" > "$file"
  echo "Headers guardados en $file"
done
