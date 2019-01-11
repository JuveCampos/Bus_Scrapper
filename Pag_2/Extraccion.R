library("RSelenium")
library(tidyverse)

#####################################
# Armamos el archivo de urls final  #
#####################################

# Abrimos el .csv
od <- readr::read_csv("Datos.csv") %>%
  select(origen, destino)

# Asignamos una fecha
fecha <- "2019-01-04"

# Generamos los urls
od$url <- paste0("https://www.clickbus.com.mx/en/search/", od$origen, "/", 
                 od$destino, "?isGroup=&ida=", fecha, "&volta=#/step/departure")

# Declaramos funciones utiles
extraerTexto <- function(x){
  c <- unlist(lapply(x, function(x){x$getElementText()}))
  c <- unlist(strsplit(c, "[\n]"))
  return(c)
}

#############################
# Inicializamos el Selenium #
#############################

# Navegacion con Selenium
# Inicio del Selenium
library("RSelenium")
library(dplyr)
library(rebus)
library(stringr)
rD <- rsDriver(verbose = FALSE)
rD
remDr <- rD$client

# Nos dirigimos a la pagina
remDr$navigate("https://www.clickbus.com.mx/en/")

for (i in 1:length(od$url)){
  remDr$navigate(od$url[i])
  print(paste0(od$origen[i], ", ", od$destino[i]))
  Sys.sleep(2)
  
  #// Proovedores
  icons <- remDr$findElements("class", "D-ib")
  icons
  
  extraerTexto(icons)
  
  #// Datos Miscelaneos
  info <- remDr$findElements("class", "info-row")
  info
  
  extraerTexto(info)
  
  #// Extraer clase de servicio
  clase <- remDr$findElements("class", "service-class")
  extraerTexto(clase)

  #// Extraer precios (esto extrae todo)
  precios <- remDr$findElements("class", "ng-binding")
  precios  
  extraerTexto(precios)

  #// Extraer proveedores
  prov <- remDr$findElements("class", "trip-data")
  prov
  extraerTexto(prov)
  
  
  
  
}


