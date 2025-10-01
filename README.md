# Practica_Calificada_2-CC3S2
Repositorio para el Proyecto 4 - Práctica Calificada 2

[Grupo2_PC2](https://github.com/Grupo2-CC3S2/Practica_Calificada_2-CC3S2)

## Integrantes
- Lazaro Dionicio, Yorklin Wilmer
- Luna Jaramillo, Christian Giovanni

### Ejecución
```bash
# Preparar entorno
make build

# Ejecutar scripts
make run

# Ejecutar pruebas bats
make test

# Verificar idempotencia
make idempt

# Limpiar el directorio
make clear
```

## Sprint 1
Este sprint en contexto de scripts se basa en crear en archivo [collector_headers.sh](src/collect_headers.sh) el cual necesitará que se definan **TARGETS** como variables de entorno, para que al ejecutar el script, este sea capaz de tomar esos targets para a partir de ahí tener una correcta ejecución, y el objetivo es guardar los resultados dados en archivos **.txt** que contendrán la respuesta que nos da al verificar el encabezado de los urls designados.

Por parte de la automatización, se crea el [**Makefile**](Makefile) con los targets básicos **make tools**, **make build**, **make run**, **make test**.

Por último las pruebas con bats se basarán en una prueba simple que validará que **collector.sh** genere archivos **.txt** con los targets

## Sprint 2
En este sprint en contexto de scripts, se basó en actualizar el script [collector_headers.sh](src/collect_headers.sh) para que ahora cree una matriz de resultados de tipo **.csv** donde guardará todos los resultados de la ejecución filtrando los **HEADERS** es decir, en ese archivo se verificará el header obtenido con el header esperado y en base a eso se asignará **OK** en caso sea el esperado y si hay falla se asignará **FAIL**.

Por parte de la automatización, se basó en aplicar el Patrón de Diseño de pruebas AAA para que en Arrange se ubiquen los comandos que se encargan de crear todo el entorno, las instancias y objetos necesarios para la ejecución correcta de los scripts y evitar errores al momento de testear, en Act se ubican la ejecución de scripts en formato **bash script/<name_script>** la cuales serán necesarias para la verificación posterior de archivos que indiquen su correcta ejecución, por último en Assert lo que hicimos fue agrupar todos los comandos de verificación en bats para verificar que los archivos **.csv** que crean los scripts sean no vacíos, que cumplan con leer los headers, que verifique la conexión hacia otros URL con comando **curl** o **ping**.

## Sprint 3
Para el último sprint en contexto de scripts, se creó un script básico [policy-rules.sh](src/policy-rules.sh) que se encarga de verificar si los headers cumplen con los requrimientos, y esto se hará verificando si el header asignado como prioridad en **OK** o **FAIL** y basandose en eso dará la misma respuesta y en este caso será si cumple los headers **Strict-Transport-Security" "Content-Security-Policy" "X-Content-Type-Options** y en caso alguno no cumpla, directamente será asignado como **FAIL** y todos esos resultados se guardarán en el archivo [policy-complieance](out/policy_compliance.csv).

Por parte de la automatización, lo que se solicitaba era aplicar todo un sistema de desempaquetado automático en la tarea **make build** y esto se logra haciendo que todos los scripts, se guarden en un archivo **.zip** ayudando que el entorno quedé totalmente vacío con ayuda de **make clear** y además que permita la automatización, por lo que se implementó ese sistema en **make build** para lo que fue necesario convertir **make tools** en un código más robusto que se base en verificar **TODAS** las dependencias necesarias usadas en el proyecto y en caso no estén instaladas en el sistema, instalarlas y así evitar el error al realizar **make run** y **make save** siendo este último el encargado de guardar todos los archivos en un **.zip**; luego de terminar con ese proceso de automatización, también se creó una tarea automática encargada de verificar que el script [collect_headers.sh](src/collect_headers.sh) sea idempotente, el cual se basa en que al ejecutar varias veces siempre nos da el mismo resultado.