#!/usr/bin/env bash
set -euo pipefail
trap "echo 'Saliendo con limpieza...'; rm -f out/tmp_* 2>/dev/null || true" EXIT

# Validar entrada
if [[ ! -f "out/security_report.csv" ]]; then
  echo "No existe out/security_report.csv. Ejecuta collect_headers.sh primero." >&2
  exit 1
fi

# Reglas de cumplimiento:
MANDATORY=("Strict-Transport-Security" "Content-Security-Policy" "X-Content-Type-Options")
OPTIONAL=("Access-Control-Allow-Origin")

input="out/security_report.csv"
output="out/policy_compliance.csv"

echo "host,compliance" > "$output"
tail -n +2 "$input" > out/tmp_results.csv