# Preprocesamiento de la informacion
library(tidyverse)
library(stringr)
library(rebus)

###########################################################
# 1. Obtencion de las claves de destino para esta pagina 
###########################################################

# 1.1 Abrimos el excel y obtenemos una lista de lugares

destinos <- readxl::read_xlsx("rutas.xlsx", sheet = "origen-destino-sur")

lugares.conguion <- c(destinos$origen, destinos$destino) %>%
  as.factor() %>%
  levels() %>%
  as.data.frame()

(lugares <- c(destinos$origen, destinos$destino) %>%
  as.factor() %>%
  levels() %>%
  stringr::str_replace_all(pattern = "-", replacement = " "))

# Obtenemos la longitud del vector de lugares
length(lugares) #// 30

#########################################################################
# 2. Nos dirijimos a la pagina ppal y metemos los resultados de la lista
#########################################################################

# Navegacion con Selenium
# Inicio del Selenium
library("RSelenium")
library(dplyr)
library(rebus)
library(stringr)
rD <- rsDriver(verbose = FALSE)
rD
remDr <- rD$client

# Creamos vector vacio
url <- c()

# Nos dirigimos a la pagina
remDr$navigate("https://www.clickbus.com.mx/en/")

for (i in 0:(length(lugares)-1)){
  # Introducimos datos de origen
  origen <- remDr$findElement("id", "originPlace")
  origen$clearElement()
  origen$sendKeysToElement(list(lugares[2*i + 1], key = 'enter'))
  Sys.sleep(1)
  
  # Introducimos datos de destino
  destino <- remDr$findElement("id", "destinationPlace")
  destino$clearElement()
  destino$sendKeysToElement(list(lugares[2*i + 2], key = 'enter'))
  print(paste("Origen",lugares[2*i + 1]))
  print(paste("Destino",lugares[2*i + 2]))
  Sys.sleep(1)
  
  # Presionamos el boton de busqueda
  search <- remDr$findElement("id", "btn-search")
  search$clickElement()
  Sys.sleep(5)
  
  # Obtenemos la url
  url[i+1] <- remDr$getCurrentUrl()
  Sys.sleep(1)
  # Regresamos
  remDr$navigate("https://www.clickbus.com.mx/en/")
  
}

# F A L T A N T E S 
# Campeche - Tehuacan
# https://www.clickbus.com.mx/en/search/campeche-camp/tehuacan-pue/?isGroup=&ida=2019-01-04&volta=#/step/departure

# Chilpancingo - Zihuatanejo
# https://www.clickbus.com.mx/en/search/chilpancingo-gro-todas-las-terminales/zihuatanejo-gro-todas-las-terminales/?isGroup=0&ida=2019-01-04&volta=#/step/departure

# Huatulco - Ciudad de Mexico
# https://www.clickbus.com.mx/en/search/huatulco-oax/ciudad-de-mexico-df-(todas-las-terminales)/?isGroup=0&ida=2019-01-04&volta=#/step/departure

# Transformamos a vector el url
url <- unlist(url)

# Añadimos los datos faltantes
url[16] <- "https://www.clickbus.com.mx/en/search/campeche-camp/tehuacan-pue/?isGroup=&ida=2019-01-04&volta=#/step/departure"
url[17] <- "https://www.clickbus.com.mx/en/search/chilpancingo-gro-todas-las-terminales/zihuatanejo-gro-todas-las-terminales/?isGroup=0&ida=2019-01-04&volta=#/step/departure"
url[18] <- "https://www.clickbus.com.mx/en/search/huatulco-oax/ciudad-de-mexico-df-(todas-las-terminales)/?isGroup=0&ida=2019-01-04&volta=#/step/departure"
url

# extraemos las etiquetas de lugar
url.df <- as.data.frame(url)

url.df <- url.df %>%
  mutate(Inicio = str_extract(url.df$url, pattern = "https://www.clickbus.com.mx/en/search/")) %>%
  mutate(Lugares = str_remove(url.df$url, pattern = "https://www.clickbus.com.mx/en/search/")) 

# Extraemos el origen
cc <- char_class("-()")
patron1 = START %R% capture(one_or_more(WRD %R% cc)) 
patron2 = "([//])" %R% capture(one_or_more(WRD %R% cc)) 
#%R% "([//])"
patronguion <- "-"

# Extraemos el origen
origen1 <- str_extract(url.df$Lugares, pattern = patron1)
# Extraemos el destino
destino1 <- str_extract(url.df$Lugares, pattern = patron2) %>%
  str_remove(pattern = "([//])") %>%
  na.omit()

# Hacemos el vector de claves y eliminamos duplicados
claves <- c(origen1, destino1) %>% unique() %>% as.data.frame() %>% arrange()

# Convertimos el archivo en Python
library(reticulate)
use_python("/Users/admin/anaconda3/bin/python")
repl_python()

############### CODIGO EN PYTHON ############################
dict = {'acapulco'	:	'acapulco-gro(todas-las-terminales)'	,
'cancun'	:	'cancun-qr-todas-las-terminales'	,
'chetumal'	:	'chetumal-qr-todas-las-terminales'	,
'ciudad-de-mexico'	:	'ciudad-de-mexico-df-(todas-las-terminales)'	,
'coatzacoalcos'	:	'coatzacoalcos-ver'	,
'cuernavaca'	:	'cuernavaca-mor-(todas-las-terminales)'	,
'merida'	:	'merida-yuc-todas-las-terminales'	,
'oaxaca'	:	'oaxaca-oax-todas-las-terminales'	,
'palenque'	:	'palenque-chis'	,
'poza-rica'	:	'poza-rica-ver-todas-las-terminales'	,
'puerto-escondido'	:	'puerto-escondido-oax'	,
'tapachula'	:	'tapachula-chis-todas-las-terminales'	,
'tulum'	:	'tulum-qr-todas-las-terminales'	,
'veracruz'	:	'veracruz-ver-todas-las-terminales'	,
'xalapa'	:	'caxa-xalapa-ver'	,
'campeche'	:	'campeche-camp'	,
'chilpancingo'	:	'chilpancingo-gro-todas-las-terminales'	,
'huatulco'	:	'huatulco-oax'	,
'cardenas'	:	'cardenas-tab-todas-las-terminales'	,
'ciudad-del-carmen'	:	'ciudad-del-carmen-camp-todas-las-terminales'	,
'cordoba'	:	'cordoba-ver'	,
'minatitlan'	:	'minatitlan-ver-todas-las-terminales'	,
'orizaba'	:	'orizaba-ver'	,
'playa-del-carmen'	:	'playa-del-carmen-qr-todas-las-terminales'	,
'puebla'	:	'puebla-pue-todas-las-terminales'	,
'salina-cruz'	:	'salina-cruz-oax'	,
'tuxtla-gutierrez'	:	'tuxtla-gutierrez-chis-todas-las-terminales'	,
'villahermosa'	:	'villahermosa-tab-todas-las-terminales'	,
'tehuacan'	:	'tehuacan-pue'	,
'zihuatanejo'	:	'zihuatanejo-gro-todas-las-terminales'}	
import pandas as pd
df1 = pd.ExcelFile("rutas.xlsx").parse('origen-destino-sur')
df1['origen']  = df1.origen.map(dict)
df1['destino'] = df1.destino.map(dict)  
df1.head()
df1.to_csv("Datos.csv")
exit
############### CODIGO EN PYTHON ############################




