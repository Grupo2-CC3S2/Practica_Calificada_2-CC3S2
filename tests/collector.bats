#!/usr/bin/env bats

# Verificador que collect_headers.sh genera un archivo CSV no vacío (caso rojo->verde)
@test "El script genera un archivo CSV no vacío" {
  run bash src/collect_headers.sh
  [ -f out/security_report.csv ]
  [ -s out/security_report.csv ]
}