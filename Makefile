
.PHONY: tools build run test

tools: # Verifica dependencias (curl, jq, bats)
	@echo "Verificar dependencias"

build: # Prepara la estructura
	@echo "Preparando estructura"

run: # Ejecutar collector.sh
	@echo "Ejecutando collector.sh"

test: # Corriendo pruebas unitarias
	@echo "Corriendo pruebas unitarias"