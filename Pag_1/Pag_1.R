##########################################
# SCRIPT PARA LA OBTENCI'ON DE LOS DATOS #
##########################################


######################
# P A S O  # 1       #
# Correr el Selenium #
######################
# Navegacion con Selenium
# Inicio del Selenium
library("RSelenium")
library(dplyr)
library(rebus)
library(stringr)
rD <- rsDriver(verbose = FALSE)
rD
remDr <- rD$client

################################
# P A S O  2:                  #
# Leer el archivo de destinos  #
# y determinar fecha de salida #
############################## #

# Leemos el archivo de Origenes/destinos
origen.destino <- read.csv("norte_sur.csv") 
origen.destino$X <- NULL

# Esto esta en otro script. Aquí ya determinamos que la fecha 
destinos <- read.csv("viajes.csv") # Este Base ya se hizo en el otro script!!
names(destinos) <- c("ID", "url")
destinos$ID <- NULL
fecha <- "30-Ene-19" #checar que sea la misma que la del otro script

length(destinos$url) # 358

#########################################################
# Creamos una matriz dummy para irle metiendo los datos #
#########################################################
#datos <- matrix(ncol = 9, nrow = 0)
remDr$navigate(destinos$url[1])

bus <- remDr$findElements("class", "transport-bus")

bus[[1]]$clickElement()
Sys.sleep(1)
length(bus)

# Creamos un vector vacio
datos <- c()

Sys.sleep(15)


#programa <- function(i = 1) {
for (i in 1:length(destinos$url)){

  ############################
  # P A S O  3:              #  
  # Accedemos a las urls que #
  # creamos con los destinos #
  ############################
  remDr$navigate(destinos$url[i])
  Sys.sleep(10)
  
  bus <- remDr$findElements("class", "transport-bus")
  if(length(bus) != 0) bus[[1]]$clickElement()
  Sys.sleep(runif(1, min = 1.5, max = 2))
  #Sys.sleep(1)
  
  ##################################
  # P A S O 4:                     #
  # Obtenemos el numero de botones #
  # que tiene cada destino (nota:  #
  # un botón es un proveedor)      #  
  ##################################
  w1 <- remDr$findElements("class", "button-primary")
  ########################################
  # PASO 5:                              #
  # Accedemos a cada una de las opciones #
  # (botones) para obtener los datos     #
  ########################################
  for (j in 2:length(w1)){
    w1 <- remDr$findElements("class", "button-primary")
    length(w1)
    w1[[j]]$clickElement()
    Sys.sleep(3)
  
    ##############################################
    # PASO 6:                                    #
    # Dado que la pagina no despliega todos      #
    # sus datos a la vez, vamos bajando el       #
    # scroll del navegador para que se revelen   #
    # todos los secretos :9                      #
    ##############################################
    
    # Bajamos el Scroll hasta haber leído todo. 
    w2 <- remDr$findElements("class", "provider-price")
    viajes <- length(w2)
    remDr$executeScript("window.scrollTo(0, 5000)")
    w2 <- remDr$findElements("class", "provider-price")
    while(viajes < length(w2)){
      viajes <- length(w2)
      remDr$executeScript("window.scrollTo(0, 5000)")
      Sys.sleep(runif(n = 1, min = 2, max = 3))
      w2 <- remDr$findElements("class", "provider-price")
      # Sys.sleep(0.5)
    } 
    
    ##################################################
    # Paso 7:                                        #
    # Una vez que la página ha revelado todos los    #
    # datos, los leemos y los guardamos de forma     #
    # estructurada                                   #
    ##################################################
    
    # Detectar los precios dentro de la pagina
    w2 <- remDr$findElements("class", "provider-price")
    # Convertir Dichos precios en Vector de datos
    precios <- unlist(lapply(w2, function(x){x$getElementText()}))
    precios <- unlist(strsplit(precios, "[\n]"))
    precios
    
    # Este capta los horarios y el tipo de servicio.
    w3 <- remDr$findElements("class", "schedules-results-font")
    caracteristicas <- unlist(lapply(w3, function(x){x$getElementText()}))
    caracteristicas <- tryCatch(unlist(strsplit(caracteristicas, "[\n]")), 
                                error = function(e){
                                  print("Error!")
                                }
                                )
    caracteristicas
    
    if(caracteristicas == "Error!") remDr$goBack()
    else{
    
    ##############
    # ESTRUCTURA #
    #############
    datos.hora.servicio <- matrix(ncol = 4, nrow = length(w2), rep(0, 4*length(w2)))
    for(k in 0:(length(precios)-1)){
      datos.hora.servicio[k+1,] <- caracteristicas[((k*4)+1):(4*(k+1))]
    }
    
    #######################################
    # Obtenemos el proveedor del servicio #
    ######################################
    
    url.actual <- remDr$getCurrentUrl()
    proveedor <- str_extract(url.actual, pattern = "departures/" %R% capture(one_or_more(WRD)) %R% 
                               optional("-") %R% optional(capture(one_or_more(WRD)))) %>%
      str_remove(pattern = "departures/") %>%
      rep(times = length(precios))
    
    
    ##################################################
    # Paso 9:                                        #
    # Le damos forma a todos nuestros datos          #
    # estructurando el Data.Frame tal como lo        #
    # queremos                                       #
    ##################################################
    
    #Columnas Faltantes:
    origen <- rep(as.character(origen.destino$origen[i]), length(precios))
    destino <- rep(as.character(origen.destino$destino[i]), length(precios))
    fecha.col <- rep(fecha, times = length(precios))
    datos <<- rbind(datos, cbind(origen, destino, precios, proveedor, datos.hora.servicio, fecha.col))
   #Sys.sleep(runif(n = 1, min = 3, max = 5))
    remDr$goBack()
    Sys.sleep(runif(n = 1, min = 3, max = 5))
    } #fin del else
  }
}

#} #fin de la funcion

# tryCatch(programa(i = 1),
#          error = function(e){
#            "Error grande!"
#          }
#   )


print(i)
print(j - 1)
Resultados <- as.data.frame(datos)

head(Resultados)
names(Resultados) <- c("Origen", "Destino", "Precios", "Proveedor", "Horario_Salida", "Horario_llegada", "Duracion_viaje", 
                       "Tipo_Servicio", "Fecha")
head(Resultados)
  

write.csv(Resultados, "Resultados.csv", fileEncoding = "UTF-8") # Solo hasta el 114

