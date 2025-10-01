# Practica_Calificada_2-CC3S2
Repositorio para el Proyecto 4 - Práctica Calificada 2

## Sprint 1
Este sprint se basará principalmente de la creación base del código **collector.sh** y las variables de entorno para que reciba TARGETS y ejecute **curl -i** contra cada endpoint para finalmente la respuesta guardarla en **out/raw-headers.csv**

Por parte de la automatización, se crea el [**Makefile**](Makefile) con los targets básicos **make tools**, **make build**, **make run**, **make test**.

Por último las pruebas con bats se basarán en una prueba simple que validará que **collector.sh** genera un archivo **.csv** no vacío y por último.