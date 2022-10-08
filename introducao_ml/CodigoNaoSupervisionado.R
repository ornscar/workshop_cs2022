#modelos hierarquicos ----------------------------

virginicas <- iris[iris$Species == 'virginica',-5]
setosas <- iris[iris$Species=='setosa',-5]

#distancia

euclidiana <- function(x1,x2) sqrt(sum(x1 - x2)^2)

euclidiana(virginicas[1,],setosas[1,])#distancia alta
euclidiana(virginicas[1,],virginicas[3,])#distancia baixa

#matriz de distancias

distance_matrix <- iris[,-5] %>% 
  dist() #euclidiana
?dist()
distance_matrix_m <- iris[,-5] %>% 
  dist(method = 'manhattan') #manhattan

#Modelo hierárquico
library(factoextra)

hclust(distance_matrix)
hclust(distance_matrix_m)

?hclust()

#dendograma

hclust(distance_matrix) %>% plot()
rect.hclust(hclust(distance_matrix), k = 3)

hclust(distance_matrix_m) %>% plot()
rect.hclust(hclust(distance_matrix_m), k = 3)

hclust(distance_matrix)$height[140:150] %>% barplot() 

library(ggdendro)
ggdendrogram(hclust(distance_matrix))

# modelos de centroides ---------------

library(tidymodels)
library(ggplot2)

iris_kmeans <- iris %>% 
  select(-Species) %>% 
  kmeans(center = 3)

iris_kmeans

iris_kmeans$totss

#usando apenas 2 variaveis no plot pra melhor visualizacao
iris %>% 
  select(-Species) %>% 
  kmeans(center = 3) %>% 
  augment(iris) %>% 
  ggplot(
    aes(Petal.Length,
        Petal.Width,
        color = .cluster)) + 
  geom_point()

centroides <- iris_kmeans$centers

#visualizando os centroides 
centroides <- iris_kmeans$centers
iris[,-5] |>
  ggplot(aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point() +
  geom_point(aes(x = centroides[1,1], y = centroides[1,2]), color = "red", size = 3)+
  geom_point(aes(x = centroides[2,1], y = centroides[2,2]), color = "red", size = 3)+
  geom_point(aes(x = centroides[3,1], y = centroides[3,2]), color = "red", size = 3)

#visualizando agora com os grupos separados
iris %>% 
  select(-Species) %>% 
  kmeans(center = 3) %>% 
  augment(iris) %>% 
  ggplot(
    aes(Sepal.Length,
        Sepal.Width,
        color = .cluster)) + 
  geom_point() +
    geom_point(aes(x = centroides[1,1], y = centroides[1,2]), color = "red", size = 3)+
    geom_point(aes(x = centroides[2,1], y = centroides[2,2]), color = "red", size = 3)+
    geom_point(aes(x = centroides[3,1], y = centroides[3,2]), color = "red", size = 3)

#Testando para varios numeros de clusters
#ver o melhor numero de clusters ( mais manual )
todos_os_twss <- c(
  (iris[,-5] |> kmeans(centers = 1, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 2, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 3, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 4, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 5, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 6, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 7, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 8, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 9, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 10, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 11, iter.max = 400))$tot.withinss,
  (iris[,-5] |> kmeans(centers = 12, iter.max = 400))$tot.withinss
)

df <- data.frame(x=c(1:12),y=todos_os_twss)
ggplot(data=df, aes(x=x, y=y, group=1)) +
  geom_line(color="red")+
  geom_point() +
  labs(x='Qtd. de grupos', y = 'Variancia Total',title = 'Método do cotovelo') +
 scale_x_continuous(breaks=seq(1, 12, 1))

# Método menos manual -----------------------------------------------------

# crash course de factorextra
# fviz é uma função pra visualizar objetos de análises não supervisionadas específicas  
# fviz_?? são funções especializadas:

fviz_nbclust(iris[,-5], kmeans, method = "wss")

fviz_nbclust(iris[,-5], hcut, method = "wss",hc_method = 'single')

# aqui concluímos que é tudo parecido!

#Circulo

dados_circulo <- tibble(
  X = runif(2000, -1, 1),
  Y = runif(2000, -1, 1)
) |>
  filter(X^2 + Y^2 <= 0.2 | (X^2 + Y^2 <= 0.8 & X^2 + Y^2 >= 0.6))


#USANDO KMEANS

qplot(dados_circulo$X, dados_circulo$Y)

dados_com_clusters_k <- dados_circulo |>
  mutate(
    .cluster = factor(kmeans(dados_circulo, centers = 2)$cluster)
  )
centroides <- kmeans(dados_circulo,2)$centers
dados_com_clusters_k |>
  ggplot(aes(x = X, y = Y, color = .cluster)) +
  geom_point() + 
  geom_point(aes(x = centroides[1,1], y = centroides[1,2]), color = "red", size = 5)+
  geom_point(aes(x = centroides[2,1], y = centroides[2,2]), color = "red", size = 5)

#USANDO HC

modelo_cluster_h <- factoextra::hcut(dados_circulo, k = 2, hc_method = "single")

dados_com_clusters_h <- dados_circulo |>
  mutate(
    .cluster = factor(modelo_cluster_h$cluster)
  )

dados_com_clusters_h |>
  ggplot(aes(x = X, y = Y, color = .cluster)) +
  geom_point()

#PADRONIZACAO DA ESCALA FORMA CANONICA
padroniza <- function(x){(x-mean(x))/sd(x)}

dados_k_medias_padr <- iris[,-5] |>
  mutate(
    Sepal.Length = padroniza(Sepal.Length),
    Sepal.Width = padroniza(Sepal.Width),
    Petal.Length = padroniza(Petal.Length),
    Petal.Width = padroniza(Petal.Width)
  )

dados_k_medias_padr %>% head()
iris %>%  head()

iris[,-5] |>
  ggplot(aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

dados_k_medias_padr |>
  ggplot(aes(x = Sepal.Length, y = Sepal.Width)) +
  geom_point()

