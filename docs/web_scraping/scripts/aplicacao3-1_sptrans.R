u_base <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint_sptrans <- "/Posicao"

# url valida

u_sptrans <- paste0(u_base, endpoint_sptrans)

# requisicao

r_sptrans <- httr::GET(u_sptrans); r_sptrans

httr::content(r_sptrans) # acesso negado

# token de acesso a api

api_key <- "4af5e3112da870ac5708c48b7a237b30206806f296e1d302e4cb611660e2e03f"

u_sptrans_login <- paste0(u_base, "/Login/Autenticar")

# parametro

q_sptrans <- list(token = api_key)

# requisicao com parametro

r_sptrans_login <- httr::POST(u_sptrans_login, query = q_sptrans)

r_sptrans_login

# verificar se a autenticacao foi realizada com sucesso

httr::content(r_sptrans_login)

u_base <- "http://api.olhovivo.sptrans.com.br/v2.1"
endpoint_sptrans <- "/Posicao"

# url valida

u_sptrans <- paste0(u_base, endpoint_sptrans)

# requisicao

r_sptrans <- httr::GET(u_sptrans); r_sptrans

# ler dados .json e transformar em um data frame

httr::content(r_sptrans, simplifyDataFrame = TRUE)

# selecionar a lista 'l'

httr::content(r_sptrans, simplifyDataFrame = TRUE) %>%
  purrr::pluck("l")

# transformar a lista 'l' em um data frame

httr::content(r_sptrans, simplifyDataFrame = TRUE) %>%
  purrr::pluck("l") %>%
  tibble::as_tibble()

# transformar variavel 'vs' em colunas regulares

httr::content(r_sptrans, simplifyDataFrame = TRUE) %>%
  purrr::pluck("l") %>%
  tibble::as_tibble() %>%
  tidyr::unnest(vs)

# grafico

httr::content(r_sptrans, simplifyDataFrame = TRUE) %>%
  purrr::pluck("l") %>%
  tibble::as_tibble() %>%
  tidyr::unnest(vs) %>%
  ggplot(aes(x = px, y = py)) + #<<
  geom_point() + #<<
  coord_fixed()







