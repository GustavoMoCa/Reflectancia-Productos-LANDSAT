#Librerias empleadas
library(rgdal)
library(sp)
library(reshape2)
library(ggplot2)
library(raster)
library(RStoolbox)
#Espacio de trabajo
setwd("D:/Asus/Documents/Ingenieria Geomatica/Semestre 2022-1/PR2/Teloloapan/LC08_L1TP_026047_20210424_20210501_01_T1")
getwd()
#Asignacion y lectura del metadato
met<-"LC08_L1TP_026047_20210424_20210501_01_T1_MTL.txt"
metadato<-readMeta(met)
#Informacion del metadato
bands<-stackMeta(met)
summary(metadato)
print(bands)
res(bands)
names(bands)
summary(bands)
getMeta(bands,metaData =metadato,what="CALRAD" )
#Para saber el numero de banda y su archivo correspondiente
getMeta(bands,metaData =metadato,what="FILES" )
#Ejemplo de visualizacion (Combinacion falso color urbano para OLLI)
plotRGB(bands,7,6,4,stretch="lin")
#Calculo de la Reflectancia TOA
refl=radCor(bands,metaData = metadato,method = "apref")
#Despliegue con bandas procesadas 
plotRGB(refl,7,6,4,stretch="lin")
names(refl)
#Estadisticos de las bandas procesadas 
summary(refl)
#Eliminando las bandas termicas (Emitivas)
refl_TOA=dropLayer(refl,9)
refl_TOA=dropLayer(refl_TOA,9)
names(refl_TOA)
#Sistema de referencia
referencia="+proj=utm +zone=14 +datum=WGS84 +units=m +no_defs"
refl_TOA_G=projectRaster(refl_TOA,crs=referencia)
#Verificacion de valores 
plot(refl_TOA_G$B1_tre)
#Recortando el area de interes
names(refl_TOA_G)
plotRGB(refl_TOA_G,7,6,4,stretch="lin")
rec=drawExtent()
refl_TOA_G_recorte=crop(refl_TOA_G,rec)
plotRGB(refl_TOA_G_recorte,4,3,2,stretch="lin")
#Exportacion de los resultados
setwd("D:/Asus/Documents/Ingenieria Geomatica/Semestre 2022-1/PR2/Teloloapan/LC08_L1TP_026047_20210424_20210501_01_T1/ReflectanciaR")
getwd()
writeRaster(refl_TOA_G,"Reflectancia_TOA_Completa.tif",drivername="Gtiff")
writeRaster(refl_TOA_G_recorte,"Reflectancia_TOA_corte.tid",drivername="Gtiff")