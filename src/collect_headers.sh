#!/usr/bin/env bash

set -euo pipefail
trap "echo 'Error o salida forzada, limpiando...'; rm -f out/tmp_*" EXIT


if [[ -z "${TARGETS:-}" ]]; then
  echo "Debes definir TARGETS (ej: export TARGETS='https://example.com https://openai.com')" >&2
  exit 1
fi
