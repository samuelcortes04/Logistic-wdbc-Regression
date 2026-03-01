install.packages("DataExplorer")
install.packages("ggplot2")
install.packages("readxl")
library(tidyverse) 
library(ggplot2)
library(DataExplorer)
library(readxl)

datos = read_excel("C:\\Downloads\\wdbc.data.xlsx")
datos

# B = 0, M = 1
datos$Diagnostico<- ifelse(datos$Diagnostico == "M", 1, 0)


#---Pregunta: ¿Qué datos implican que un tumor sea benigno o maligno?---#

#---Datos básicos---#
datos

fil = nrow(datos) # 569 filas/Registros
fil
col = ncol(datos) # 32 Columnas, 2 Categóricas (ID, Diagnostico) las otras 30 numéricas se dividen en 3. 1 es la media 2 es el error estándar y 3 el más grande
col

plot_missing(datos)
#No hay nulos o valores faltantes

#---Histogramas---#
plot_histogram(datos)
ggplot(datos, aes(x = Diagnostico)) +
  geom_bar(fill = "skyblue", color = "black") +
  geom_text(stat = "count", aes(label = ..count..), vjust = -0.3, size = 5) +
  labs(title = "Distribución del diagnóstico",
       x = "Diagnóstico",
       y = "Frecuencia") +
  theme_minimal()


#---Estadíticos de tendencia central ---#
summary(datos)

#---Correlaciones---#
mat_cor=cor(datos)
mat_cor
plot_correlation(datos)
#Las variables que más predicen 
# el diagnóstico son radius1, perimeter1, area1, radius3, perimeter3 y area3, 
# pero como están muy correlacionadas por el su misma naturaleza (aunque si quieren después puedo checar su correlacion modelandolas entre ellas), 
#propongo elegir solo las mejores de cada grupo:

# - perimeter1 (0.742) y concave_points1 (0.776) del grupo 1
# - perimeter3 (0.782) y concave_points3 (0.793) del grupo 3
#Ahí si quieren agregar otra o algo así pues diganlo jejeje