TARGETS ?= https://openai.com https://example.com
export TARGETS

OUT_DIR := out
SRC_DIR := src
TESTS_DIR := tests
DIST_DIR := dist
report := ${OUT_DIR}/security_report.csv

.DEFAULT_GOAL := help

.PHONY: tools build run test help clear idempt clear-all

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
	@if ! command -v unzip >/dev/null 2>&1; then \
		echo "unzip no esta instalado. Instalando..."; \
		apt-get install unzip -y; \
	else \
		echo "unzip ya esta instalado."; \
	fi

build: # Prepara la estructura
	@echo "Preparando estructura"
	@make tools
	@echo "Desempaquetando en ${DIST_DIR}"
	@mkdir -p ${OUT_DIR}
	@mkdir -p ${SRC_DIR}
	@mkdir -p ${TESTS_DIR}
	@unzip -o ${DIST_DIR}/scripts.zip
	@mv collect_headers.sh ${SRC_DIR}/collect_headers.sh
	@mv collector.bats ${TESTS_DIR}/collector.bats
	@chmod +x ${SRC_DIR}/collect_headers.sh
	@rm -rf collect_headers.sh collector.bats
	@echo "Archivos creados, estructura preparada"
	@echo "Para ejecutar, make run"

run: # Ejecutar collect_headers.sh
	@echo "Ejecutando collect_headers.sh"
	@if [ -z "$$TARGETS" ]; then \
		echo "Debes definir TARGETS (ej: make run TARGETS='https://example.com https://openai.com')"; \
		exit 1; \
	fi
	@bash ${SRC_DIR}/collect_headers.sh
	@echo "Ejecución completada. Revisa ${report} para el reporte."


test: # Corriendo pruebas unitarias
	@echo "Corriendo pruebas unitarias"
	@bats ${TESTS_DIR}/collector.bats
	@echo "Pruebas unitarias completadas"

clear: # Limpia archivos generados
	@echo "Limpiando archivos generados"
	@rm -f ${report}
	@rm -f ${OUT_DIR}/headers_*.txt
	@echo "Archivos generados limpiados"

clear-all: # Limpia todo, inclutendo directorios
	@echo "Limpiando todo"
	@rm -rf ${OUT_DIR} ${SRC_DIR} ${TESTS_DIR}
	@echo "Todo limpiado"

idempt: # Verifica idempotencia de make run
	@echo "Verificando idempotencia de 'make run'"
	@make run
	@cp ${report} ${report}.tmp
	@make clear
	@make run
	@if cmp -s ${report} ${report}.tmp; then \
		echo "Idempotencia verificada: El reporte no cambió en la segunda ejecución."; \
	else \
		echo "Idempotencia fallida: El reporte cambió en la segunda ejecución."; \
		exit 1; \
	fi
	@rm -f ${report}.tmp
	@echo "Verificación de idempotencia completada"