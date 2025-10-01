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

@test "El reporte marca FAIL si falta un header" {
  # Arrange
  rm -f out/security_report.csv

  # Act
  run bash src/collect_headers.sh

  # Assert
  [ "$status" -eq 0 ]
  grep -q "FAIL" out/security_report.csv
}

@test "El reporte marca OK si un header está presente" {
  # Arrange
  rm -f out/security_report.csv

  # Act
  run bash src/collect_headers.sh

  # Assert
  [ "$status" -eq 0 ]
  grep -q "OK" out/security_report.csv
}


# Verificación de archivo CSV no vacío
@test "El script genera un archivo CSV no vacío" {
  # Arrange
  rm -f out/security_report.csv

  # Act
  run bash src/collect_headers.sh

  # Assert
  [ "$status" -eq 0 ]
  [ -f out/security_report.csv ]
  [ -s out/security_report.csv ]
}

# Verificación de contenido del CSV
@test "Endpoints accesibles responden (ejemplo.com)" {
  # Act
  run curl -s -o /dev/null -w "%{http_code}" https://example.com

  # Assert
  [ "$status" -eq 0 ]
  [ "$output" -eq 200 ]
}

# Verificación de contenido del CSV
@test "Endpoints restringidos devuelven error (openai.com)" {
  # Act
  run curl -s -o /dev/null -w "%{http_code}" https://openai.com

  # Assert
  [ "$status" -eq 0 ]
  [ "$output" -ge 400 ]
}
