library(tidyverse)
library(dados)

dados <- pinguins

dados |> 
  ggplot()


dados |> 
  ggplot(aes(x = massa_corporal, y = comprimento_nadadeira))  


dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira)) 


ggplot(dados, aes(massa_corporal, comprimento_nadadeira))


dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira, 
             color = especie))



dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira,
             color = ilha)) + 
  geom_point() # falar sobre warning

### mapear cor específica

dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira)) + 
  geom_point(color = "purple")



dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira)) + 
  geom_point(color = ilha)



dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira,
             color = "purple")) + 
  geom_point()


## aes() dentro da geom vs aes() global


dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) +
  geom_point(aes(color = ilha))


dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) +
  geom_point(aes(color = ilha), size = 4) + 
  geom_point()

# -----------------------------------------------

## geom_bar "vs" geom_col 

# geom_bar: faz conta (agrupada)

dados |> 
  ggplot() + 
  aes(x = ilha) + 
  geom_bar()

# 1º agregrou a minha base contando quantas "ilhas" tem

# geom_col: não faz conta

dados |> 
  ggplot() + 
  aes(x = ilha) + 
  geom_col() # vai dar erro


dados |>
  count(ilha) |> 
  ggplot() + 
  aes(x = ilha, y = n) + 
  geom_col()

## para entender 

g_col <- dados |> 
  count(ilha)

# geom_line

voos |> 
  count(mes, companhia_aerea) |> 
  ggplot() +
  aes(x = mes, y = n, color = companhia_aerea) + 
  geom_line()

## densidade: geom_histogram e geom_density

# geom_histogram
dados |> 
  ggplot() + 
  aes(x = massa_corporal) + 
  geom_histogram() # colocar bins 


# geom_density
dados |> 
  ggplot() + 
  aes(x = massa_corporal) + 
  geom_density()


dados |> 
  ggplot() + 
  aes(x = massa_corporal, y = ..density..) + 
  geom_histogram() + 
  geom_density()

### preencher 

dados |> 
  ggplot() + 
  aes(x = massa_corporal, y = ..density..) + 
  geom_histogram(bins = 15) + 
  geom_density(fill = "purple", # fazer com color antes
               alpha = 0.5)




# -----------------------trocar slide----------------------------
# -----------------------otimização visual----------------------------

### cores 
# brewer: variaveis discretas 
# distiller: continuas 
# fermenter: continuas -> discretas

colorspace::hcl_color_picker()

#mostrar paletas nos helps 
# ?scale_color_brewer


dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ilha) +
  geom_point() + 
  scale_color_brewer(
    palette = "Dark2",
    direction = -1
  ) 
# color ou fill, depende dq foi usado
# help em scale_color_brewer() e mostrar as pelletas

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ilha) +
  geom_point() + 
  scale_color_viridis_d(
    #option = "E"
    #na.value = "black",
    #begin = .2,
    #end = .8
  )
# begin e end, onde a paleta começa e termina

### manual

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ilha) +
  geom_point() + 
  scale_color_manual(
    values = c("black", "orange", "blue")
  )
# o vetor precisa ter o mesmo tamanho ou mais dos argumentos


### variaveis continuas 
dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ano) +
  geom_point() +
  scale_color_distiller(
    palette = "OrRd",
    direction = 1
  )
### --- scale_color_gradiente cria um intervalo de cores --- 

### nesse caso, pode ser melhor separar os valores

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ano) +
  geom_point() +
  scale_color_fermenter(
    palette = "OrRd",
    direction = 1
  )

### para viris 

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ano) +
  geom_point() +
  scale_color_viridis_c() # trocar "c" por "d"

### temas 

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ilha) +
  geom_point() + 
  theme_light()

## outros pacotes de temas 
library(ggthemes)
library(tvthemes)

gthemas <-   dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira, color = ilha) +
  geom_point()

gthemas +
  ggthemes::theme_clean()


gthemas + 
  tvthemes::theme_simpsons()


# ---------------------------

pinguin_rei <- dados |> 
  filter(massa_corporal == 6300)



p <- dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) + 
  geom_point()


































imagem <- "https://wallpaperaccess.com/full/2010663.jpg"

ggimage::ggbackground(
  p, imagem
)









