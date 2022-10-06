library(tidyverse)
library(dados)
# mostrar os dados 
# pesquisar pacote dados no r
dados <- pinguins

## primeiro passo: a base/tapetinho cinza

dados |> 
  ggplot()

## segundo passo: mapeamento estético

dados |> 
  ggplot(aes(x = massa_corporal, y = comprimento_nadadeira))  
  
### posso omitir o "x" e "y" 

dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira)) 


### ou, sem usar o pipe 

ggplot(dados, aes(massa_corporal, comprimento_nadadeira))

### o aes() possui "x", "y" e os "..."
### esses "..." são atributos que precisamos nomear
### o aes() foi pensado para ser expansivo, criado mais
### aqui no aes() podemos ter cor, tamanho, xmin, xlab

## ex: outros mapementro (cor)

dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira, 
             color = especie))


## terceiro passo: formas geométricas

### tem vários geom_* disponíveis. uma forma de agrupar é
### geoms "individuais" (uma linha da base) colunas
### geoms "agrupados" (conjunto de linhas) barras

### geom_point

dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira,
             color = ilha)) + 
  geom_point()

### Warning message:Removed 2 rows containing 
### esta removendo valores vazios, n tem onde plotar
### mostrar help do geom "?geom_point"


## mapear uma cor específica

dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira)) + 
  geom_point(color = "purple")

### quando eu coloco um atributo pra tudo e quando no aes()
### se estou mapeando uma variável da base = aes()
### se estou mapeando um valor fixo = fora

## exemplo de errados 

dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira)) + 
  geom_point(color = ilha)

### "ilha" não existe, é uma coluna da base


dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira,
             color = "purple")) + 
  geom_point()

### não de erro, mas assume que estou criando uma nova 
### coluna com o valor "purple"


## aes() dentro da geom vs aes() global

# mapeamente global: todas as geometrias que vierem
### vão assumir essa aes(), se a geom nao usar as 
### geometrias, sem problemas, se usar, sera a global

dados |> 
  ggplot(aes(massa_corporal, comprimento_nadadeira)) + 
  geom_point(aes(color = ilha)) 



# ou 

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) +
  geom_point(aes(color = ilha))

# mapeamente local: apenas aquela geometria ira 
### usar aquele mapeamento (aes())

## ex mapeamento local: 

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) +
  geom_point(aes(color = ilha), size = 4) + 
  geom_point() # aqui nai foi usado color = ilha


### qual usar é decisão sua, pode considerar o grafico
## o mais comum é usar o global,
## local pode ser usado quando usa mais de uma base

# -----------------------------------------------
  
## geom_bar "vs" geom_col 
  
# geom_bar: faz conta (agrupada)

dados |> 
  ggplot() + 
  aes(x = ilha) + 
  geom_bar()

# 1º agregrou a minha base contando quantas "ilhas" tem

# geom_col: NÃO faz conta

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


## o geom_col pode ser mais util pois nem sempre 
## queremos fazer contagem, podemos querer a media p/ ex

# geom_line
## na nosa base temos variavel tempo (ano), mas apenas 3
## para o exemplo ficar melhor vamos usar outra base

voos |> 
  count(mes, companhia_aerea) |> 
  ggplot() +
  aes(x = mes, y = n, color = companhia_aerea) + 
  geom_line()
# voos por mes por companhia aerea

## densidade: geom_histogram e geom_density

# geom_histogram
dados |> 
  ggplot() + 
  aes(x = massa_corporal) + 
  geom_histogram() # colocar bins 


## olhar como esta concentrada uma variavel numeria
## decide sozinho quantas barras ele quer criar (bins)
## e conta quantos "valores" tem em cada intervalo


# geom_density
dados |> 
  ggplot() + 
  aes(x = massa_corporal) + 
  geom_density()

## faz uma conta complexica, mas é basicamente uma 
## suavização do hist


# caso queira plotar um junto do outro 
## adaptar os eixos 

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
  geom_density(fill = "purple",
               alpha = 0.4) # fazer com color antes




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
  # dar help em scale_color_brewer() e mostrar as pelletas

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
### falar um pouco sobre temas
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
  

#-----------voltar para o slide--------------




#---------------------------------

# um grafico um pouco mais elaborado 

### pinguim pesado 
pinguin_rei <- dados |> 
  filter(massa_corporal == 6300)

p <- dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) + 
  #ggpubr::background_image(img) + 
  geom_point(
    shape = 23,
    fill = "yellow",
    color = "#fc3f00",
    alpha = 1,
    size = 2.5
  ) + 
  geom_point(
    data = pinguin_rei,
    shape = 23,
    fill = "red",
    color = "yellow",
    size = 2.5
  ) +
  geom_label(
    data = pinguin_rei,
    aes(label = "RICO"),
    fill = "red",
    color = "black",
    size = 2.5,
    nudge_x = -5,
    nudge_y = 2
  ) + 
  labs(x = "massa corporal",
       y = "comprimento da nadadeira", 
       title = "Os pinguins de madagascar") +
  scale_x_continuous(
    breaks = seq(0, 6000, 1000),
    labels = paste(seq(0, 6000, 1000), "g")
    ) + # mudar a sequencia
  scale_y_continuous(
    breaks = seq(0, 250, 10),
    labels = paste(seq(0, 250, 10), "mm")
  ) +  # help na base para ver unidade de medias
  # dar help em theme e mostrar todos argumentos
  theme(
    #axis.text = element_blank() "tira os textos"
    text = element_text(color = "yellow",
                        face = "bold"),
    axis.text = element_text(color = "yellow",
                             face = "italic"),
    panel.grid.minor.x = element_blank(),
    panel.grid.major.x = element_blank(),
    panel.grid.major.y = element_line(color = "gray6"),
    plot.title = element_text(
      size = 30,
      hjust = .5
    ),
    plot.background = element_rect(fill = "black"),
    panel.background = element_rect(fill = "black")
  )

# --------------------- passo a passo 

## primeiro passo

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) + 
  geom_point()


## --- legendas 

labs(x = "massa corporal",
     y = "comprimento da nadadeira", 
     title = "Os pinguins de madagascar") 

## --- controlar valores dos eixos

scale_x_continuous(
  breaks = seq(0, 6000, 1000),
  labels = paste(seq(0, 6000, 1000), "g")
) + # mudar a sequencia
  scale_y_continuous(
    breaks = seq(0, 250, 10),
    labels = paste(seq(0, 250, 10), "mm"))
# help na base para ver unidade de medias


## --- geom_point 

geom_point(
  shape = 23,
  fill = "yellow",
  color = "#fc3f00",
  alpha = 1,
  size = 2.5
) # falar sobre os shapes, alpha e size

## --- tema 
# dar help em theme e mostrar todos argumentos

theme(
  #axis.text = element_blank() "tira os textos"
  axis.text = element_text(), # comentar sobre possibilidade
  title = element_text(color = "yellow",
                      face = "bold"), # titulos
  axis.text = element_text(color = "yellow",
                           face = "italic"), # exixos
  panel.grid.minor.x = element_blank(), # linhas dos eixos 
  panel.grid.major.x = element_blank(), # major = maior
  panel.grid.major.y = element_line(color = "gray6"),
  plot.title = element_text(
    size = 30,
    hjust = .5
  ), # ajustar o titulo
  plot.background = element_rect(fill = "black"),
  panel.background = element_rect(fill = "white")
)
  
### --- inserir outro pinguin 
### rico
pinguin_rei <- dados |> 
  filter(massa_corporal == 6300)
  

geom_point(
  data = pinguin_rei,
  shape = 23,
  fill = "red",
  color = "yellow",
  size = 2.5
) ## inserir novo ponto com aes local

## inserir um "texto"
## aqui inserir os elementos passo a passo
geom_label(
  data = pinguin_rei,
  aes(label = "RICO"),
  fill = "red",
  color = "black",
  size = 2.5,
  nudge_x = -5,
  nudge_y = 2
) 

## --- inserir a imagem de fundo 
# --- outra forma de imagem (com webscraping)


imagem <- "https://wallpaperaccess.com/full/2010663.jpg"
ggimage::ggbackground(
  p, imagem
)# p = grafico salvo em um objeto



library(jpeg)
img <- readJPEG("pinguins2.jpg")

dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) + 
  ggpubr::background_image(img)
  #### inserir restante do grafico



# --- outra forma de imagem 
library(grid)
dados |> 
  ggplot() + 
  aes(massa_corporal, comprimento_nadadeira) + 
  annotation_custom(rasterGrob(img, 
                               width = unit(1,"npc"), 
                               height = unit(1,"npc")), 
                    -Inf, Inf, -Inf, Inf) 
  #### inserir restante do grafico
  








