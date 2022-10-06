# Exemplo 1 ---------------------------------------------------------------

u_base <- "https://brasilapi.com.br/api"
endpoint_cep <- "/cep/v2/"
cep <- "66085370"

# url valida

u_cep <- paste0(u_base, endpoint_cep, cep)

# requisicao

r_cep <- httr::GET(u_cep); r_cep 

# extrair conteudo da requisicao em formato de texto

httr::content(r_cep, as = "text")

# ler dados .json e transformar em um data frame

httr::content(r_cep, "text") %>% 
  jsonlite::fromJSON(simplifyDataFrame = TRUE)

# transformar em um data frame

content(r_cep, as = "text") %>% 
  jsonlite::fromJSON(simplifyDataFrame = TRUE) %>% 
  tibble::as_tibble()

# acessar conteudo das listas da variavel 'location'

content(r_cep, as = "text") %>% 
  jsonlite::fromJSON(simplifyDataFrame = TRUE) %>% 
  tibble::as_tibble() %>% 
  purrr::pluck("location", "coordinates")


# Exemplo 2 ---------------------------------------------------------------

u_base <- "https://brasilapi.com.br/api"
endpoint_carro_fipe <- "/fipe/preco/v1/"
cod_carro_fipe <- "0560111" # Troller

# url valida

u_carro <- paste0(u_base, endpoint_carro_fipe, cod_carro_fipe)

# requisicao

r_carro <- httr::GET(u_carro); r_carro

# ler dados .json e transformar em um data frame

d_carro_22 <- httr::content(r_carro, simplifyDataFrame = TRUE) %>% 
  tibble::as_tibble()

# Parametro tabelas

u_base <- "https://brasilapi.com.br/api"
endpoint_tabelas <- "/fipe/tabelas/v1"

# url valida

u_tabelas <- paste0(u_base, endpoint_tabelas)

# requisicao

r_tabelas <- httr::GET(u_tabelas); r_tabelas

# localizar codigo referente a dez/2019

httr::content(r_tabelas, simplifyDataFrame = TRUE) %>% 
  tibble::as_tibble() %>% 
  print(n = 50)

# parametro

q_fipe <- list(tabela_referencia = 249)

# requisicao com parametro

r_carro_19 <- httr::GET(u_carro, query = q_fipe); r_carro_19

# ler dados .json e transformar em um data frame

d_carro_19 <- httr::content(r_carro_19, simplifyDataFrame = TRUE) %>% 
  tibble::as_tibble()# requisicao com parametro

# comparar precos de 2019 e 2022

d_carro_19 %>% 
  dplyr::select(valor, anoModelo) # valor do carro em 2019 #<< 

d_carro_22 %>% 
  dplyr::select(valor, anoModelo) # valor do carro em 2022 #<< 



