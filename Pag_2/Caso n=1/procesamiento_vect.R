library(stringr)
library(rebus)
library(tidyverse)
captura <- function(x) capture(one_or_more(x))
niveles <- function(x) levels(as.factor(x))
# Apertura y revision de datos 
a <- readr::read_csv("Texto.csv")

# 1. Quitamos las primeras 11 observaciones
a <- a[12:nrow(a), ]
a$X1 <- rownames(a)

# 2. Detectamos las horas, el "Select" y quitamos el MXN
# Patrones
pat_h <- START %R% captura(DGT) %R% ":" %R% captura(DGT) %R% SPC %R% "Hrs" %R% END
pat_select <- START %R% "Select"
pat_MXN <- "MXN"
pat_precio <- START %R% captura(DGT) %R% END
pat_class <- START %R% "Class: "

# Visores (descomentar para que funcionen)
    #str_view(a$x, pattern = pat_h)
    #str_view(a$x, pattern = pat_select)
    #str_view(a$x, pattern = pat_MXN)
    str_view(a$x, pattern = pat_precio)
    str_view(a$x, pattern = pat_class)
    
# Dummies
a$fecha <- str_detect(a$x, pat_h)
a$select <- str_detect(a$x, pat_select)
a$mxn <- str_detect(a$x, pat_MXN)
a$precio <- str_detect(a$x, pat_precio)
a$clase <- str_detect(a$x, pat_class)

# Eliminamos basura 
a <- a %>% filter(select != TRUE) %>% filter(mxn != TRUE)

#%>% select(x, fecha)

# Dividimos en grupos
for (i in 2:length(a$fecha)) {
  if (a$fecha[i - 1] == TRUE) a$fecha[i] <- FALSE
}

for (i in 2:length(a$precio)) {
  if (a$precio[i - 1] == TRUE) a$precio[i] <- FALSE
}

grupo <- c(1)
for (i in 2:length(a$fecha)) {
 if(a$fecha[i] == TRUE)  grupo[i] <- grupo[i-1] +1
 if(a$fecha[i] == FALSE) grupo[i] <- grupo[i-1]
}

a$grupo <- grupo


matriz <- splitt[[1]][1:5]
for (i in 2:76){
 matriz <-  rbind(matriz, splitt[[i]][1:5])
}


