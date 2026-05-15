head(iris)
str(iris)
summary(iris)

 ## Estatistica basica ##
mean(iris$Sepal.Length)
median(iris$Sepal.Length)
sd(iris$Sepal.Length)
range(iris$Sepal.Length)
    ## media do comprimento da sepala por especie ##
aggregate(Sepal.Length ~ Species, data = iris, mean)
    ## Coeficiente de Variação ##
sd(iris$Sepal.Length) / mean(iris$Sepal.Length) *100
   ##Boxplot-diagrama de caixa##
boxplot(iris$Sepal.Length,
        main = "Distribuição do comprimento da Sépala",
        ylab = "Cetimentros",
        col = "lightblue")

boxplot(Petal.Length ~ Species,
        data = iris,
        main = "Comprimento da Pétala por Espécie",
        xlab = "Espécie",
        ylab = "Comprimento da Pétala",
        col = c("red", "green", "blue"))
