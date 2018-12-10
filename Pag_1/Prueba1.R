##################################################################################
# Preparación de la informacion                                                  #
# Este script sirve para preparar las rutas url que se le introducir'an al       #
# programa encargado de realizar el proceso de scrappin' o captura de los datos  #
##################################################################################

###############################
# Leemos el excel de destinos #
##############################

# Excel preparado por Valentin para los destinos al norte 
norte <- readxl::read_xlsx("rutas.xlsx", sheet = "origen-destino-norte") 

# Excel preparado por Valentin para los destinos al norte 
sur <- readxl::read_xlsx("rutas.xlsx", sheet = "origen-destino-sur")

# Analizamos la cantidad de observaciones
length(norte$origen)
length(sur$destino)

# DEFINIMOS LA FECHA DE INTERES
fecha <<- "30-Ene-19"

# Guardamos los norte.sur en un solo archivo 
norte.sur <- as.data.frame(rbind(norte, sur)) # HACEMOS EL APPEND CON rbind()
write.csv(norte.sur, "norte_sur.csv")         # Escribimos el nuevo archivo en la computadora

# Numero de observaciones
length(destinos$url)

# Creamos los urls con un loop que pegue origen y destino (NORTE) en base a la base que creamos 
viajes.norte <- c()
for (i in 1:length(norte$origen)){
  link <- paste0("https://viaje.reservamos.mx/search/", norte$origen[i],"/",norte$destino[i], "/", fecha, "/p/A1/providers")
  viajes.norte[i] <- link
}
# Exploramos la base
head(viajes.norte)

# Creamos los urls con un loop que pegue origen y destino (NORTE) en base a la base que creamos 
viajes.sur <- c()
for(i in 1:length(sur$origen)){
  link <- paste0("https://viaje.reservamos.mx/search/", sur$origen[i],"/",sur$destino[i], "/", fecha, "/p/A1/providers")
  viajes.sur[i] <- link
}
# Exploramos la base
viajes.sur

# Hacemos un vector con todos los destinos y lo guardamos en un csv
viajes <- c(viajes.norte, viajes.sur)
write.csv(viajes, "viajes.csv")

# 
# destinos <- read.csv("viajes.csv")
# names(destinos) <- c("ID", "url")
# destinos$ID <- NULL
#  