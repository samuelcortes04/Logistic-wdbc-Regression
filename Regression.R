install.packages("readxl")
install.packages("tidyverse")
install.packages("caTools")
install.packages("caret")
install.packages("dplyr")
install.packages("pROC")
install.packages("car")

library(readxl)
library(tidyverse)
library(caTools)
library(caret)
library(dplyr)
library(pROC)
library(car)

data <- read_excel("C:\\Downloads\\wdbc.data.xlsx")
data
str(data)
summary(data)

data$Diagnostico <- factor(data$Diagnostico, levels = c("B", "M")) #B=0, M=1
summary(data)

# Seleccionamos solo las variables *_1 pq todas están muy correlacionadas
vars_mean <- c("Diagnostico",
               "radius1", "texture1", "perimeter1", "area1", "smoothness1",
               "compactness1", "concavity1", "concave_points1",
               "symmetry1", "fractal_dimension1")

data_mean <- data[, vars_mean]

# Split estratificado (hice la división aquí mismo)
set.seed(123)
train_index <- createDataPartition(data_mean$Diagnostico, p = 0.7, list = FALSE)
train <- data_mean[train_index, ]
test  <- data_mean[-train_index, ]

# Estandarizamos para que los datos se comporten mejor
train_estand <- train %>% mutate(across(-Diagnostico, scale))
test_estand  <- test  %>% mutate(across(-Diagnostico, scale))

#Modelo final (si quieren ver todo el proceso les puedo pasar todo el código que hice)
modelo <- glm(formula = Diagnostico ~ texture1 + area1 + smoothness1 + 
                  concavity1, family = "binomial", data = train_estand)
summary(modelo)

prob_pred <- predict(modelo, newdata = test_estand, type = "response")
roc_obj <- roc(test_estand$Diagnostico, prob_pred)
auc_value <- auc(roc_obj)
auc_value

plot(roc_obj, main = paste("Curva ROC - AUC:", round(auc_value, 3)))


test_estand$Diagnostico <- ifelse(test_estand$Diagnostico == "M", 1, 0)
test_estand$Diagnostico <- factor(test_estand$Diagnostico, levels = c("0","1"))
#Matriz de confusión con punto de corte optimo
prob_test <- predict(modelo, newdata = test_estand, type = "response")
roc_test <- roc(test_estand$Diagnostico, prob_test)
cort_opt <- coords(roc_test, "best", ret = "threshold")
cort_opt <- as.numeric(cort_opt$threshold)
cort_opt
pred_clases_opt <- ifelse(prob_test >= cort_opt, 1, 0)
pred_clases_opt <- factor(pred_clases_opt, levels = c("0","1"))
#Matríz de confusión con punto óptimo
confusionMatrix(pred_clases_opt, test_estand$Diagnostico, positive = "1")

# --- SUPUESTOS DEL MODELO LOGÍSTICO ---

# 1. Linealidad 
car::crPlots(modelo) 
# Interpretación:
# En cada variable se compara la curva suavizada (línea roja) contra la relación lineal teórica (línea azul).
# Como las curvas son prácticamente coincidentes en las cuatro variables, el supuesto de linealidad del logit se cumple.

# 2. Multicolinealidad
vif <- vif(modelo)
print(vif)
# Interpretación:
# Todos los VIF están por debajo de 5 (el mayor es ~2.12), lo que indica que no existe multicolinealidad problemática.

# 3. Independencia de las observaciones
# Las filas representan pacientes distintos y no hay dependencia temporal ni agrupamientos.
# Por lo tanto, se asume independencia entre observaciones, cumpliendo este supuesto.

# 4. Registros influyentes
influencia <- car::influencePlot(modelo, id.method = "identify")

cook <- cooks.distance(modelo)
plot(cook, type = "h")
abline(h = 4/length(cook), lty = 2)

# Interpretación:
# Se identifican algunos puntos influyentes según Cook’s distance.
# Sin embargo, en este tipo de datos biomédicos los valores extremos suelen corresponder a variaciones reales entre pacientes.
# Por tanto, no se consideran errores ni anomalías y se decidió conservarlos, 
# especialmente porque el modelo mantiene un desempeño excelente (AUC ≈ 0.98).