# tests/collector.bats
#!/usr/bin/env bats

setup_file() {
  export TARGETS="https://openai.com https://example.com"
}

# Verificación de archivo CSV no vacío
@test "El script genera un archivo CSV no vacío" {
  run bash src/collect_headers.sh
  [ -f out/security_report.csv ]
  [ -s out/security_report.csv ]
}

# Verificación de contenido del CSV
@test "Endpoints accesibles responden (ejemplo.com)" {
  run curl -s -o /dev/null -w "%{http_code}" https://example.com
  [ "$status" -eq 0 ]
  [ "$output" -eq 200 ]
}

# Verificación de contenido del CSV
@test "Endpoints restringidos devuelven error (openai.com)" {
  run curl -s -o /dev/null -w "%{http_code}" https://openai.com
  [ "$status" -eq 0 ]
  [ "$output" -ge 400 ]
}
