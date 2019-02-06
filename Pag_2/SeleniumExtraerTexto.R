# Funcion Extraer texto Selenium

extraerTexto <- function(x){
  c <- unlist(lapply(x, function(x){x$getElementText()}))
  c <- unlist(strsplit(c, "[\n]"))
  return(c)
}