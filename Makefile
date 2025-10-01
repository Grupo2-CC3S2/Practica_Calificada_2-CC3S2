TARGETS ?= https://openai.com https://example.com https://github.com
export TARGETS

OUT_DIR := out
SRC_DIR := src
TESTS_DIR := tests
DIST_DIR := dist
report := ${OUT_DIR}/security_report.csv
policy := ${OUT_DIR}/policy_compliance.csv

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
	@if ! command -v zip >/dev/null 2>&1; then \
		echo "zip no esta instalado. Instalando..."; \
		apt-get install zip -y; \
	else \
		echo "zip ya esta instalado."; \
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
	@mv policy-rules.sh ${SRC_DIR}/
	@mv collector.bats ${TESTS_DIR}/
	@chmod +x ${SRC_DIR}/collect_headers.sh
	@chmod +x ${SRC_DIR}/policy-rules.sh
	@echo "Archivos creados, estructura preparada"
	@echo "Para ejecutar, make run"

run: # Ejecutar collect_headers.sh
	@echo "Ejecutando collect_headers.sh"
	@if [ -z "$$TARGETS" ]; then \
		echo "Debes definir TARGETS (ej: make run TARGETS='https://example.com https://openai.com')"; \
		exit 1; \
	fi
	@bash ${SRC_DIR}/collect_headers.sh > /dev/null 2>&1
	@echo "Ejecución completada. Revisa ${report} para el reporte."
	@echo "Ejecutando policy-rules.sh"
	@bash ${SRC_DIR}/policy-rules.sh > /dev/null 2>&1
	@echo "Políticas aplicadas. Revisa ${policy} para el reporte final."


test: # Corriendo pruebas unitarias
	@make clear-files
	@echo "Corriendo pruebas unitarias"
	@bats ${TESTS_DIR}/collector.bats
	@echo "Pruebas unitarias completadas"

clear-files: # Limpia archivos generados
	@echo "Limpiando archivos generados"
	@rm -f ${report}
	@rm -f ${policy}
	@rm -f ${OUT_DIR}/headers_*.txt
	@echo "Archivos generados limpiados"

clear: # Limpia todo, inclutendo directorios
	@make save
	@echo "Limpiando todo"
	@rm -rf ${OUT_DIR} ${SRC_DIR} ${TESTS_DIR}
	@echo "Todo limpiado"

idempt: # Verifica idempotencia de make run
	@echo "Verificando idempotencia de 'make run'"
	@echo "------Primera ejecución------"
	@make run > /dev/null 2>&1
	@cp ${report} ${report}.tmp
	@cp ${policy} ${policy}.tmp
	@make clear-files
	@echo "------Segunda ejecución------"
	@make run > /dev/null 2>&1
	@echo "Resultados:"
	@if cmp -s ${report} ${report}.tmp; then \
		echo "- Idempotencia verificada para collector_headers.sh: El archivo ${report} no cambió en la segunda ejecución."; \
	else \
		echo "- Idempotencia fallida: El archivo ${report} cambió en la segunda ejecución."; \
		exit 1; \
	fi
	@if cmp -s ${policy} ${policy}.tmp; then \
		echo "- Idempotencia verificada para policy-rules.sh: El archivo ${policy} no cambió en la segunda ejecución."; \
	else \
		echo "- Idempotencia fallida: El archivo ${policy} cambió en la segunda ejecución."; \
		exit 1; \
	fi
	@rm -f ${policy}.tmp
	@rm -f ${report}.tmp
	@echo "Verificación de idempotencia completada"

save: # Empaqueta los scripts en un zip
	@rm -f ${DIST_DIR}/scripts.zip
	@echo "Empaquetando scripts en ${DIST_DIR}/scripts.zip"
	@zip -j ${DIST_DIR}/scripts.zip ${SRC_DIR}/collect_headers.sh ${SRC_DIR}/policy-rules.sh ${TESTS_DIR}/collector.bats
	@echo "Empaquetado completado"