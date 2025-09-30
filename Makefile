
.DEFAULT_GOAL := help

.PHONY: tools build run test help

help: # Muestra los comandos disponibles
	@echo "Comandos disponibles:"
	@echo "  make tools  - Verifica e instala dependencias (curl, jq, bats)"
	@echo "  make build  - Prepara la estructura"
	@echo "  make run    - Ejecuta collector.sh"
	@echo "  make test   - Corre pruebas unitarias"

tools: # Verifica dependencias (curl, jq, bats)
	@if ! command -v curl >/dev/null 2>&1; then \
		echo "curl no esta instalado. Instalando..."; \
		apt-get install curl; \
	else \
		echo "curl ya esta instalado."; \
	fi
	@if ! command -v jq >/dev/null 2>&1; then \
		echo "jq no esta instalado. Instalando..."; \
		apt-get install jq; \
	else \
		echo "jq ya esta instalado."; \
	fi
	@if ! command -v bats >/dev/null 2>&1; then \
		echo "bats no esta instalado. Instalando..."; \
		apt-get install bats; \
	else \
		echo "bats ya esta instalado."; \
	fi

build: # Prepara la estructura
	@echo "Preparando estructura"
	@make tools
	@echo "Estructura preparada"
	@echo "Puedes ejecutar 'make run' para iniciar el script principal."

run: # Ejecutar collector.sh
	@echo "Ejecutando collector.sh"

test: # Corriendo pruebas unitarias
	@echo "Corriendo pruebas unitarias"