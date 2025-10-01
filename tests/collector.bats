#!/usr/bin/env bats

setup_file() {
  # Arrange global: definir los targets
  export TARGETS="https://example.com https://github.com https://openai.com"
}

@test "El script genera un reporte CSV con matriz de headers" {
  # Arrange
  rm -f out/security_report.csv  # limpiar antes

  # Act
  run bash src/collect_headers.sh

  # Assert
  [ "$status" -eq 0 ]
  [ -f out/security_report.csv ]
  [ -s out/security_report.csv ]
  grep -q "Strict-Transport-Security" out/security_report.csv
  grep -q "Content-Security-Policy" out/security_report.csv
  grep -q "X-Content-Type-Options" out/security_report.csv
  grep -q "Access-Control-Allow-Origin" out/security_report.csv
}
