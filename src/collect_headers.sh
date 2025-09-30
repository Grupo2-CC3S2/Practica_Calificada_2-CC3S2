#!/usr/bin/env bash

set -euo pipefail
trap "echo 'Error o salida forzada, limpiando...'; rm -f out/tmp_*" EXIT
