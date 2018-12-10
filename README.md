# Bus_Scrapper
Códigos para la extracción de datos de paginas proveedoras de transporte terrestre.

## USO
Este código trabaja con RSelenium, el cual es una librería que utiliza el webdriver [Selenium](https://www.seleniumhq.org), que nos ayuda a automatizar labores dentro de un navegador. El razonamiento detras del funcionamiento de este "scrapper" es el automatizar las consultas que haría un ser humano desde su navegador Chrome para consultar los precios de viajes de autobús en determinadas fechas. 

Para su correcto funcionamiento, hay que descargar las siguientes librerías desde RStudio: 
* `RSelenium`
* `dplyr`
* `rebus`
* `stringr`
* `readxl`

El paquete `RSelenium` requiere de los entornos de Java para poder funcionar. Estos son de descarga obligatoria y se pueden obtener en los siguientes enlaces: 

* https://www.oracle.com/technetwork/java/javase/downloads/jdk8-downloads-2133151.html

_Nota de Juve: creo que hay que descargar otra cosa de Java que ya no recuerdo... pero el RSelenium lo va indicando conforme vamos corriendo el script_.

## Instrucciones

### Para la pag_1

* Paso 1. Abrir el archivo _NuevoProyecto.Rproj_ (Suponiendo que ya se tiene la ultima versión de RStudio instalada en el ordenador y se tienen instalados los paquetes mencionados previamente, lo que sería el **paso 0**).
* Paso 2. Abrir el script _Prueba_1.r_. En este archivo creamos los datos de entrada para el Scrapper. Hay que ajustar la fecha de interés, corroborar que los archivos `*.xslx` tienen los datos que queremos (se pueden añadir o quitar destinos, a gusto del investigador) y corremos el script.
* Paso 3. Una vez que tenemos nuestra base de `urls` como datos de entrada, abrimos el archivo `Pag_1.r`. Ajustamos la fecha y corremos.

### Errores mas comunes.

* **Error 1.** Si dice algo así como "_ERROR: port 4567L is already in use_" el Selenium está ocupado y no puede volver a realizar el Scrapper. No se como solucionar este error pero lo que se puede hacer es guardar los datos, cerrar el RStudio y volverlo a abrir 😅.

* **Error 2.** Si el programa tiene un error, pero la ventana de Chrome no esta crasheada y se puede ver que no había un registro para ese destino, anotar el numero `i` que despliega la consola de RStudio. Este numero `i` nos ayuda a saber en que registro se quedó el programa. Con ese numero, ir a la linea 54 (donde dice `for (i in 1:length(destinos$url))`) y hay que sustituir ese numero **1** por el numero `i` mas uno para que el loop inicie desde donde se quedó. 

_Nota 2 de Juve: Este error se puede corregir con la función tryCatch() pero me dió flojera... lo resolveré para la siguiente versión y cuando tenga mas tiempo_

_Nota 3 de Juve: Igualmente, este truco de numero i funciona como una especie de Checkpoint. Si tienes 2 o mas computadoras configuradas con el Java y los paquetes, puedes hacer que empiecen de puntos distintos de la base y después hacer un merge_.

Por cualquier duda estoy en mi correo _jcampos@colmex.mx_.




